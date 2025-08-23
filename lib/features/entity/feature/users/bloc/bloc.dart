library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/core/data/model/api_error.dart';
import 'package:moh_eam/features/entity/feature/users/data/model/create_user.dart';
import 'package:moh_eam/features/entity/feature/users/data/model/delete_user.dart';
import 'package:moh_eam/features/entity/feature/users/data/model/fetch_user_details_model.dart';
import 'package:moh_eam/features/entity/feature/users/data/model/fetch_users_model.dart';
import 'package:moh_eam/features/entity/feature/users/data/model/patch_user.dart';
import 'package:moh_eam/features/entity/feature/users/data/repositories/users_entity_repository_imp.dart';
import 'package:moh_eam/features/entity/feature/users/domain/repositories/user_repository.dart';
import 'package:moh_eam/features/entity/feature/users/domain/services/create_user.dart';
import 'package:moh_eam/features/entity/feature/users/domain/services/delete_user.dart';
import 'package:moh_eam/features/entity/feature/users/domain/services/fetch_user_details.dart';
import 'package:moh_eam/features/entity/feature/users/domain/services/fetch_users.dart';
import 'package:moh_eam/features/entity/feature/users/domain/entity/user_entity.dart';
import 'package:moh_eam/features/entity/feature/users/domain/services/patch_user.dart';

part 'state.dart';
part 'event.dart';

final class UserEntityBloc extends Bloc<UserEntityEvent, UserEntityState> {
  final UsersEntityRepository _repo = UsersEntityRepositoryImp();

  UserEntityBloc() : super(const UserEntityState()) {
    _filters();
    _fetchUsers();
    _fetchUserDetails();
    _create();
    _delete();
    _patch();
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
        emit(state.copyWith(event: FetchUserFailedEvent(reason: messageKey)));
        return;
      }

      Logger.d(
        'fetching users exit success:[${usersModel.users.length}] - Users, number of pages = ${usersModel.total}',
        tag: 'UsersEntityBloc',
      );
      emit(
        state.copyWith(
          event: const FetchUserSuccessEvent(),
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
        emit(state.copyWith(event: FetchUserFailedEvent(reason: messageKey)));
        return;
      }

      final user = userModel.user!;

      Logger.d(
        'fetching user details exit success:[${user.username}]',
        tag: 'UsersEntityBloc',
      );
      emit(
        state.copyWith(event: FetchUserSuccessEvent(), user: user.toDomain()),
      );
    });
  }

  void _create() {
    CreateUserResponse? then(CreateUserResponse res) {
      if (res.code != 201) throw res.messageKey;
      return res;
    }

    on<CreateUserEvent>((event, emit) async {
      emit(state.copyWith(event: UserEntityLoadingEvent()));
      Logger.d('Creating new user...', tag: 'UserEntityBloc');

      String key = '';

      CreateUserRequest request = CreateUserRequest(
        user: event.user,
        password: event.password,
      );

      CreateUserService service = CreateUserService(_repo);

      CreateUserResponse? res = await service
          .call(token: event.token, req: request)
          .then(then)
          .catchError((e) {
            key = handleError(e);
            return null;
          });

      Logger.i('Create user response received', tag: 'UserEntityBloc');

      if (key.isNotEmpty || res == null) {
        emit(state.copyWith(event: CreateUserFailedEvent(reason: key)));
        Logger.e('Create user failed with key: $key', tag: 'UserEntityBloc');
        return;
      }

      Logger.d('User created successfully', tag: 'UserEntityBloc');

      emit(state.copyWith(event: CreateUserSuccessEvent()));
    });
  }

  void _delete() {
    DeleteUserResponse? then(DeleteUserResponse res) {
      if (res.code != 200) throw res.messageKey;
      return res;
    }

    on<DeleteUserEvent>((event, emit) async {
      emit(state.copyWith(event: UserEntityLoadingEvent()));
      Logger.d('Delete user: ${event.user}', tag: 'UserEntityBloc');

      String key = '';

      DeleteUserService service = DeleteUserService(_repo);

      DeleteUserResponse? res = await service
          .call(token: event.token, user: event.user)
          .then(then)
          .catchError((e) {
            key = handleError(e);
            return null;
          });
      Logger.i('Delete user response received', tag: 'UserEntityBloc');

      if (key.isNotEmpty || res == null) {
        emit(state.copyWith(event: DeleteUserFailedEvent(reason: key)));
        Logger.e('Delete user failed with key: $key', tag: 'UserEntityBloc');
        return;
      }

      Logger.d('Delete user succeed', tag: 'UserEntityBloc');
      emit(state.copyWith(event: DeleteUserSuccessEvent()));
    });
  }

  void _patch() {
    PatchUserResponse? then(PatchUserResponse res) {
      if (res.code != 200) throw res.messageKey;
      return res;
    }

    on<UpdateUserEvent>((event, emit) async {
      emit(state.copyWith(event: UserEntityLoadingEvent()));
      Logger.d('Patching user: ${event.request.id}', tag: 'UserEntity');

      String key = '';

      PatchUserService service = PatchUserService(_repo);

      PatchUserResponse? res = await service
          .call(token: event.token, request: event.request)
          .then(then)
          .catchError((e) {
            key = handleError(e);
            return null;
          });

      Logger.i('Patch response received', tag: 'UserEntityBloc');

      if (key.isNotEmpty || res == null) {
        emit(state.copyWith(event: UpdateUserFailedEvent(reason: key)));
        Logger.e('Patching user failed with key: $key', tag: 'UserEntityBloc');
        return;
      }

      Logger.d('Patch user success', tag: 'UserEntityBloc');
      emit(state.copyWith(event: UpdateUserSuccessEvent()));
    });
  }
}
