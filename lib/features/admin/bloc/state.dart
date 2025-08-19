part of 'bloc.dart';

final class AdminState {
  final List<UserEntity> users;
  final List<DepartmentEntity> departments;
  final List<RoleEntity> roles;
  final List<DeviceEntity> devices;
  final Map<String, int> stats;
  final AdminEvent event;
  final int totalDevices, totalUsers;

  const AdminState({
    this.users = const [],
    this.departments = const [],
    this.roles = const [],
    this.devices = const [],
    this.stats = const {},
    this.event = const AdminInitialEvent(),
    this.totalDevices = 0,
    this.totalUsers = 0,
  });

  AdminState copyWith({
    List<UserEntity>? users,
    List<DepartmentEntity>? departments,
    List<RoleEntity>? roles,
    List<DeviceEntity>? devices,
    Map<String, int>? stats,
    AdminEvent? event,
    int? totalDevices,
    int? totalUsers,
  }) {
    return AdminState(
      users: users ?? this.users,
      departments: departments ?? this.departments,
      roles: roles ?? this.roles,
      devices: devices ?? this.devices,
      stats: stats ?? this.stats,
      event: event ?? this.event,
      totalDevices: totalDevices ?? this.totalDevices,
      totalUsers: totalUsers ?? this.totalUsers,
    );
  }
}
