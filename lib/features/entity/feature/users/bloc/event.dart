part of 'bloc.dart';

sealed class UserEntityEvent {
  const UserEntityEvent({this.message = ''});
  final String message;
}

final class UserEntityInitialEvent extends UserEntityEvent {
  const UserEntityInitialEvent();
}

final class UserEntityLoadingEvent extends UserEntityEvent {
  const UserEntityLoadingEvent();
}

final class UserEntityFetchUsersEvent extends UserEntityEvent {
  const UserEntityFetchUsersEvent({required this.token});

  final String token;
}

final class UserEntitySearchFiltersChanged extends UserEntityEvent {
  final FilterValue<String?>? locale, role, department, query;
  final FilterValue<bool?>? hasDevice;
  final FilterValue<int> page;
  final FilterValue<int> limit;

  const UserEntitySearchFiltersChanged({
    this.query,
    this.page = const UpdateTo(1),
    this.limit = const UpdateTo(15),
    this.locale = const UpdateTo('ar'),
    this.role,
    this.department,
    this.hasDevice,
  });
}

final class UserEntityFetchUserDetailsEvent extends UserEntityEvent {
  const UserEntityFetchUserDetailsEvent({
    required this.token,
    required this.userId,
  });
  final String token;
  final String userId;
}

final class CreateUserEvent extends UserEntityEvent {
  final String token, password;
  final UserEntity user;
  const CreateUserEvent({
    required this.token,
    required this.user,
    required this.password,
  });
}

final class UpdateUserEvent extends UserEntityEvent {
  final String token;
  final PatchUserRequest request;
  const UpdateUserEvent({required this.token, required this.request});
}

final class DeleteUserEvent extends UserEntityEvent {
  final String token, user;
  const DeleteUserEvent({required this.token, required this.user});
}

sealed class UserEntitySuccessEvent extends UserEntityEvent {
  final String title;
  const UserEntitySuccessEvent({
    this.title = 'user_success_title_general',
    super.message = 'user_success_message_general',
  });
}

sealed class UserEntityFailedEvent extends UserEntityEvent {
  final String title, reason;
  const UserEntityFailedEvent({
    this.title = 'user_failed_title_general',
    super.message = 'user_failed_message_general',
    required this.reason,
  });
}

final class FetchUserSuccessEvent extends UserEntitySuccessEvent {
  const FetchUserSuccessEvent();
}

final class FetchUserFailedEvent extends UserEntityFailedEvent {
  const FetchUserFailedEvent({required super.reason});
}

final class CreateUserSuccessEvent extends UserEntitySuccessEvent {
  const CreateUserSuccessEvent({
    super.title = 'user_success_title_create',
    super.message = 'user_success_message_create',
  });
}

final class CreateUserFailedEvent extends UserEntityFailedEvent {
  const CreateUserFailedEvent({
    super.title = 'user_failed_title_create',
    super.message = 'user_failed_message_create',
    required super.reason,
  });
}

final class UpdateUserSuccessEvent extends UserEntitySuccessEvent {
  const UpdateUserSuccessEvent({
    super.title = 'user_success_title_update',
    super.message = 'user_success_message_update',
  });
}

final class UpdateUserFailedEvent extends UserEntityFailedEvent {
  const UpdateUserFailedEvent({
    super.title = 'user_failed_title_update',
    super.message = 'user_failed_message_update',
    required super.reason,
  });
}

final class DeleteUserSuccessEvent extends UserEntitySuccessEvent {
  const DeleteUserSuccessEvent({
    super.title = 'user_success_title_delete',
    super.message = 'user_success_message_delete',
  });
}

final class DeleteUserFailedEvent extends UserEntityFailedEvent {
  const DeleteUserFailedEvent({
    super.title = 'user_failed_title_delete',
    super.message = 'user_failed_message_delete',
    required super.reason,
  });
}
