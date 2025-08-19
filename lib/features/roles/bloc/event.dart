part of 'bloc.dart';

sealed class RoleEvent {
  final String message;
  const RoleEvent({this.message = ''});
}

sealed class RoleSuccessEvent extends RoleEvent {
  final String title;
  const RoleSuccessEvent({
    this.title = 'role_success_title_general',
    super.message = 'role_success_message_general',
  });
}

sealed class RoleFailedEvent extends RoleEvent {
  final String title, reason;
  const RoleFailedEvent({
    this.title = 'role_failed_title_general',
    super.message = 'role_failed_message_general',
    required this.reason,
  });
}

final class InitialRoleEvent extends RoleEvent {
  const InitialRoleEvent();
}

final class PendingRoleEvent extends RoleEvent {
  const PendingRoleEvent();
}

final class FetchRolesEvent extends RoleEvent {
  final String token;
  const FetchRolesEvent({required this.token});
}

final class FetchRolesSuccessEvent extends RoleSuccessEvent {
  const FetchRolesSuccessEvent();
}

final class FetchRolesFailedEvent extends RoleFailedEvent {
  const FetchRolesFailedEvent({required super.reason});
}

final class RoleCreateEvent extends RoleEvent {
  final CreateRoleRequest request;
  final String token;
  const RoleCreateEvent({required this.request, required this.token});
}

final class RoleCreateSuccessEvent extends RoleSuccessEvent {
  const RoleCreateSuccessEvent({
    super.title = 'role_success_title_create',
    super.message = 'role_success_message_create',
  });
}

final class RoleCreateFailedEvent extends RoleFailedEvent {
  const RoleCreateFailedEvent({
    super.title = 'role_failed_title_create',
    super.message = 'role_failed_message_create',
    required super.reason,
  });
}

final class RoleDeleteEvent extends RoleEvent {
  final String token, id;
  const RoleDeleteEvent({required this.token, required this.id});
}

final class RoleDeleteSuccessEvent extends RoleSuccessEvent {
  const RoleDeleteSuccessEvent({
    super.title = 'role_success_title_delete',
    super.message = 'role_success_message_delete',
  });
}

final class RoleDeleteFailedEvent extends RoleFailedEvent {
  const RoleDeleteFailedEvent({
    super.title = 'role_failed_title_delete',
    super.message = 'role_failed_message_delete',
    required super.reason,
  });
}
