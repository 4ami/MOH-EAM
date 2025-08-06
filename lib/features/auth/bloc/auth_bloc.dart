library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/core/data/model/api_error.dart';
import 'package:moh_eam/features/auth/data/models/auth_model.dart';
import 'package:moh_eam/features/auth/data/repositories/auth_repo_implementation.dart';
import 'package:moh_eam/features/entity/feature/users/domain/entity/user_entity.dart';
import 'package:moh_eam/features/auth/domain/repositories/auth_repo.dart';
import 'package:moh_eam/features/auth/domain/services/sign_in_service.dart';
import 'package:moh_eam/features/auth/domain/services/sign_out_service.dart';
import 'package:moh_eam/features/auth/domain/services/token_service.dart';

part 'event.dart';
part 'state.dart';

final class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _repo = AuthRepoImplementation();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  AuthBloc() : super(UnAuthenticatedState()) {
    _setUsername();
    _setPassword();
    _authenticate();
    _token();
    _refresh();
    _signout();
  }

  void _setUsername() {
    on<UsernameChanged>((event, emit) {
      if (state is! UnAuthenticatedState) emit(UnAuthenticatedState());
      emit(
        (state as UnAuthenticatedState).copyWith(
          event: event,
          username: event.username,
        ),
      );
    });
  }

  void _setPassword() {
    on<PasswordChanged>((event, emit) {
      if (state is! UnAuthenticatedState) emit(UnAuthenticatedState());
      emit(
        (state as UnAuthenticatedState).copyWith(
          event: event,
          password: event.password,
        ),
      );
    });
  }

  String handleError(dynamic e) {
    Logger.e('key: ', tag: 'Bloc Handler', error: e);
    if (e is ApiException) return e.key;
    if (e is String) return e;
    return 'general_error_message';
  }

  void _authenticate() {
    AuthModel? then(AuthModel r) {
      if (r.code != 200) {
        Logger.e(
          'Authentication Failed duo to:\n${r.message}',
          tag: 'AuthBloc[Authentcation]',
        );
        throw r.messageKey;
      }
      return r;
    }

    on<AuthenticateEvent>((event, emit) async {
      emit(state.copyWith(event: const AuthPendingEvent()));
      var unautstate = (state as UnAuthenticatedState);
      String username = unautstate.username, password = unautstate.password;

      SignInService service = SignInService(_repo);

      String messageKey = '';
      AuthModel? user = await service
          .call(username: username, password: password, locale: event.locale)
          .then(then)
          .catchError((e) {
            messageKey = handleError(e);
            return null;
          });

      if (messageKey.isNotEmpty || user == null) {
        emit(state.copyWith(event: AuthenticationFailed(message: messageKey)));
        return;
      }

      await _storage.write(key: 'ref_token', value: user.refToken);

      emit(
        AuthenticatedState(
          token: user.token,
          user: UserEntity.fromToken(token: user.token),
          event: const AuthenticationSuccess(),
        ),
      );
    });
  }

  void _token() {
    on<AccessTokenRefreshed>((event, emit) async {
      UserEntity user = UserEntity.fromToken(token: event.token);
      emit(
        AuthenticatedState(
          user: user,
          token: event.token,
          event: AuthenticationSuccess(),
        ),
      );
    });
  }

  void _refresh() {
    AuthModel? then(AuthModel model) {
      if (model.token.isEmpty) throw 'authentication_needed_message';
      return model;
    }

    on<RefreshToken>((event, emit) async {
      Logger.d('Start refresh token', tag: '[AuthBloc]');
      emit(state.copyWith(event: const AuthPendingEvent()));

      final refToken = await _storage.read(key: 'ref_token');

      bool isUndifiend = refToken == null;

      if (isUndifiend) {
        emit(
          state.copyWith(
            event: AuthenticationFailed(
              message: 'authentication_needed_message',
            ),
          ),
        );
        return;
      }

      bool isInvalid = JwtDecoder.tryDecode(refToken) == null;
      bool isExpired = JwtDecoder.isExpired(refToken);

      if (isInvalid || isExpired) {
        Logger.e('Refresh token failed', tag: '[AuthBloc]');
        emit(
          state.copyWith(
            event: AuthenticationFailed(
              message: 'authentication_needed_message',
            ),
          ),
        );
        return;
      }

      String messageKey = '';

      TokenService service = TokenService(_repo);

      AuthModel? model = await service
          .call(refToken: refToken)
          .then(then)
          .catchError((e) {
            messageKey = handleError(e);
            return null;
          });

      if (messageKey.isNotEmpty || model == null) {
        emit(
          state.copyWith(
            event: AuthenticationFailed(
              message: 'authentication_needed_message',
            ),
          ),
        );
        return;
      }

      String token = model.token;
      final user = UserEntity.fromToken(token: token);
      emit(
        AuthenticatedState(
          token: token,
          user: user,
          event: AuthenticationSuccess(),
        ),
      );
    });
  }

  void _signout() {
    on<SignoutAuthEvent>((event, emit) async {
      SignOutService service = SignOutService(_repo);
      await service.call();
      emit(UnAuthenticatedState(event: event));
    });
  }
}
