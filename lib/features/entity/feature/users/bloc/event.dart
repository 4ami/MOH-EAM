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

final class UserEntitySuccessEvent extends UserEntityEvent {
  const UserEntitySuccessEvent();
}

final class UserEntityFailedEvent extends UserEntityEvent {
  const UserEntityFailedEvent({required super.message});
}
