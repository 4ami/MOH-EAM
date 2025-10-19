part of '_routing_helpers_module.dart';

final class RouteDataClass {
  final String name, path;
  const RouteDataClass({required this.name, required this.path});
}

final class AppRoutesInformation {
  static final RouteDataClass splash = RouteDataClass(
    name: 'splash_screen',
    path: '/',
  );

  static final RouteDataClass signin = RouteDataClass(
    name: 'signin',
    path: '/signin',
  );

  static final RouteDataClass admin = RouteDataClass(
    name: 'admin',
    path: '/admin',
  );

  static final RouteDataClass userManagement = RouteDataClass(
    name: 'user_managment',
    path: 'entity/users',
  );

  static final RouteDataClass viewUser = RouteDataClass(
    name: 'user_details',
    path: 'user/view/:user',
  );

  static final RouteDataClass departmentManagment = RouteDataClass(
    name: 'department_managment',
    path: 'entity/departments',
  );

  static final RouteDataClass viewDepartment = RouteDataClass(
    name: 'department_details',
    path: 'department/view/:department',
  );

  static final RouteDataClass devicesManagment = RouteDataClass(
    name: 'device_managment',
    path: 'entity/devices',
  );

  static final RouteDataClass rolesManagment = RouteDataClass(
    name: 'roles_managment',
    path: 'roles',
  );

  static final RouteDataClass entityViewer = RouteDataClass(
    name: 'entity_viewer',
    path: ':resource/:id',
  );

  static final RouteDataClass editUser = RouteDataClass(
    name: 'edit_user',
    path: 'edit/user',
  );

  static final RouteDataClass editDepartment = RouteDataClass(
    name: 'edit_department',
    path: 'edit/department',
  );

  static final RouteDataClass editDevice = RouteDataClass(
    name: 'edit_device',
    path: 'edit/device',
  );

  static final RouteDataClass searchResults = RouteDataClass(
    name: 'search_results',
    path: 'search/results',
  );

  static final RouteDataClass guestPage = RouteDataClass(
    name: 'guest',
    path: '/guest/profile',
  );

  static final RouteDataClass logsPage = RouteDataClass(
    name: 'logs',
    path: 'movements/logs',
  );
}
