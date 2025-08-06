library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/core/data/model/api_error.dart';
import 'package:moh_eam/features/entity/feature/users/data/model/fetch_user_details_model.dart';
import 'package:moh_eam/features/entity/feature/users/data/model/fetch_users_model.dart';
import 'package:moh_eam/features/entity/feature/users/data/repositories/users_entity_repository_imp.dart';
import 'package:moh_eam/features/entity/feature/users/domain/repositories/user_repository.dart';
import 'package:moh_eam/features/entity/feature/users/domain/services/fetch_user_details.dart';
import 'package:moh_eam/features/entity/feature/users/domain/services/fetch_users.dart';
import 'package:moh_eam/features/entity/feature/users/domain/entity/user_entity.dart';

part 'state.dart';
part 'event.dart';

final class UserEntityBloc extends Bloc<UserEntityEvent, UserEntityState> {
  final UsersEntityRepository _repo = UsersEntityRepositoryImp();

  UserEntityBloc() : super(const UserEntityState()) {
    _filters();
    _fetchUsers();
    _fetchUserDetails();
  }

  String handleError(dynamic e) {
    Logger.e('key: ', tag: 'Bloc Handler', error: e);
    if (e is ApiException) return e.key;
    if (e is String) return e;
    return 'general_error_message';
  }

  void _filters() {
    on<UserEntitySearchFiltersChanged>((event, emit) {
      emit(
        state.copyWith(
          page: event.page,
          limit: event.limit,
          locale: event.locale,
          query: event.query,
          role: event.role,
          department: event.department,
          hasDevice: event.hasDevice,
        ),
      );
    });
  }

  void _fetchUsers() {
    FetchUsersModel? then(FetchUsersModel res) {
      if (res.code != 200) throw res.messageKey;
      return res;
    }

    on<UserEntityFetchUsersEvent>((event, emit) async {
      Logger.d('Start fetching users', tag: 'UsersEntityBloc');
      emit(state.copyWith(event: const UserEntityLoadingEvent()));

      String messageKey = '';

      final FetchUsers service = FetchUsers(_repo);

      final FetchUsersModel? usersModel = await service
          .call(
            query: state.filters.query,
            page: state.filters.page,
            limit: state.filters.limit,
            token: event.token,
            locale: state.filters.locale,
            role: state.filters.role,
            hasDevice: state.filters.hasDevice,
            department: state.filters.department,
          )
          .then(then)
          .catchError((e) {
            messageKey = handleError(e);
            return null;
          });

      Logger.d('fetching users response recieved...', tag: 'UsersEntityBloc');
      if (messageKey.isNotEmpty || usersModel == null) {
        Logger.d(
          'fetching users exit with error: [$messageKey]',
          tag: 'UsersEntityBloc',
        );
        emit(state.copyWith(event: UserEntityFailedEvent(message: messageKey)));
        return;
      }

      Logger.d(
        'fetching users exit success:[${usersModel.users.length}] - Users, number of pages = ${usersModel.total}',
        tag: 'UsersEntityBloc',
      );
      emit(
        state.copyWith(
          event: const UserEntitySuccessEvent(),
          maxPage: usersModel.total,
          users: List.generate(
            usersModel.users.length,
            (i) => usersModel.users[i].toDomain(),
          ),
        ),
      );
    });
  }

  void _fetchUserDetails() {
    FetchUserDetailsModel? then(FetchUserDetailsModel res) {
      if (res.code != 200) throw res.messageKey;
      return res;
    }

    on<UserEntityFetchUserDetailsEvent>((event, emit) async {
      Logger.d('Start fetching user details', tag: 'UsersEntityBloc');
      emit(state.copyWith(event: const UserEntityLoadingEvent()));

      String messageKey = '';

      FetchUserDetails service = FetchUserDetails(_repo);

      final FetchUserDetailsModel? userModel = await service
          .call(token: event.token, userId: event.userId)
          .then(then)
          .catchError((e) {
            messageKey = handleError(e);
            return null;
          });

      Logger.d(
        'fetching user detail response recieved...',
        tag: 'UsersEntityBloc',
      );

      if (messageKey.isNotEmpty || userModel == null) {
        Logger.d(
          'fetching user detail exit with error: [$messageKey]',
          tag: 'UsersEntityBloc',
        );
        emit(state.copyWith(event: UserEntityFailedEvent(message: messageKey)));
        return;
      }

      final user = userModel.user!;

      Logger.d(
        'fetching user details exit success:[${user.username}]',
        tag: 'UsersEntityBloc',
      );
      emit(
        state.copyWith(event: UserEntitySuccessEvent(), user: user.toDomain()),
      );
    });
  }
}
