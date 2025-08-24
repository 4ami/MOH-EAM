part of 'bloc.dart';

sealed class AdminEvent {
  const AdminEvent({this.message = ''});

  final String message;
}

final class AdminInitialEvent extends AdminEvent {
  const AdminInitialEvent();
}

final class AdminLoadEvent extends AdminEvent {
  const AdminLoadEvent();
}

final class AdminDashboardLoadEvent extends AdminEvent {
  const AdminDashboardLoadEvent();
}

final class AdminDashboardSuccess extends AdminEvent {
  const AdminDashboardSuccess();
}

final class AdminDashboardFailed extends AdminEvent {
  const AdminDashboardFailed({required super.message});
}

/// [Fetch] events for the Admin feature
/// [These events are used to fetch data from the server]
/// [Each event requires a token for authentication]
/// [The token is passed as a parameter to the event]
/// [The events are used to fetch data for the admin dashboard, users, departments, roles, and devices]
/// [AdminFetchDashboardEvent] fetches the dashboard data (e.g., statistics, metrics, metadata)
/// [metadata] like total users, total departments, total devices, roles ids and names, etc.
final class AdminFetchDashboardEvent extends AdminEvent {
  const AdminFetchDashboardEvent({required this.token, this.locale = 'ar'});
  final String token, locale;
}

/// [AdminFetchUsersEvent] fetches the list of users
final class AdminFetchUsersEvent extends AdminEvent {
  const AdminFetchUsersEvent({
    this.departmentId,
    this.roleId,
    this.searchQuery,
    this.hasDevices,
    this.page = 1,
    required this.token,
  });
  final String token;
  final int page;

  ///Users can be filtered by department
  final String? departmentId;

  ///Users can be filtered by role
  final String? roleId;

  ///Users can be filtered by search query
  final String? searchQuery;

  ///Users can be filtered by devices (e.g., devices assigned to users)
  final bool? hasDevices;
}

/// [AdminFetchDepartmentsEvent] fetches the list of departments
final class AdminFetchDepartmentsEvent extends AdminEvent {
  const AdminFetchDepartmentsEvent({required this.token});
  final String token;
}

/// [AdminFetchRolesEvent] fetches the list of roles
final class AdminFetchRolesEvent extends AdminEvent {
  const AdminFetchRolesEvent({required this.token});
  final String token;
}

/// [AdminFetchDevicesEvent] fetches the list of devices
/// [This event is used to fetch the devices managed by the admin]
final class AdminFetchDevicesEvent extends AdminEvent {
  const AdminFetchDevicesEvent({required this.token});
  final String token;
}

/// [AdminSuccessEvent] is used to indicate a successful operation
/// [This event can be used to trigger UI updates or show success messages]
final class AdminSuccessEvent extends AdminEvent {
  const AdminSuccessEvent();
}

/// [AdminErrorEvent] is used to indicate an error during an operation
/// [This event can be used to show error messages or handle errors in the UI]
final class AdminErrorEvent extends AdminEvent {
  const AdminErrorEvent({required super.message});
}

final class AdminGlobalSearchEvent extends AdminEvent {
  final String token, query;
  const AdminGlobalSearchEvent({required this.token, required this.query});
}

final class AdminGlobalSearchSuccess extends AdminEvent {
  final List<UserEntity> users;
  final List<DeviceEntity> devices;
  const AdminGlobalSearchSuccess({required this.users, required this.devices});
}

final class AdminGlobalSearchFailed extends AdminEvent {
  final String title, reason;
  const AdminGlobalSearchFailed({
    this.title = 'global_search_failed_title',
    super.message = 'global_search_failed_message',
    required this.reason,
  });
}
