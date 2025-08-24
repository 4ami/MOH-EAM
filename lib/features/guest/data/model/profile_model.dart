import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/auth/data/models/user_model.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/department.dart';
import 'package:moh_eam/features/entity/feature/devices/data/model/device.dart';
import 'package:moh_eam/features/guest/domain/entity/profile.dart';

class ProfileModel extends BaseResponse {
  final UserModel user;
  final List<DeviceModel>? devices;
  final DepartmentModel? department;

  const ProfileModel({
    super.code,
    super.message,
    super.messageKey,
    required this.user,
    this.devices,
    this.department,
  });

  factory ProfileModel.fromJSON(dynamic json) {
    return ProfileModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      user: UserModel.fromJSON(json['user']),
      devices: List.generate(
        json['user']['devices'].length,
        (i) => DeviceModel.fromJSON(json['devices'][i]),
      ),
      department: DepartmentModel.fromJson(json['user']['department']),
    );
  }

  ProfileEntity toDomain() {
    return ProfileEntity(
      user: user.toDomain(),
      devices: devices?.map((d) => d.toDomain()).toList(),
      department: department?.toDomain(),
    );
  }
}
