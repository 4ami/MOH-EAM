import 'package:moh_eam/features/entity/feature/departments/domain/entity/department.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/entity/device.dart';
import 'package:moh_eam/features/entity/feature/users/domain/entity/user_entity.dart';

class ProfileEntity {
  final UserEntity user;
  final List<DeviceEntity>? devices;
  final DepartmentEntity? department;

  const ProfileEntity({
    required this.user,
    this.devices = const [],
    this.department,
  });
}
