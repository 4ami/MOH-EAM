import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/department.dart';
import 'package:moh_eam/features/auth/data/models/roles.dart';
import 'package:moh_eam/features/auth/domain/entities/role.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/entity/department.dart';
import 'package:moh_eam/features/auth/domain/entities/user_entity.dart';

class UserModel extends BaseResponse {
  const UserModel({
    super.code,
    super.message,
    super.messageKey,
    required this.id,
    required this.username,
    required this.fullNameAR,
    required this.fullNameEN,
    required this.email,
    required this.mobile,
    this.role,
    this.department,
    this.roleModel,
  });

  factory UserModel.fromJSON(dynamic json) {
    return UserModel(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      fullNameAR: json['full_name_ar'],
      fullNameEN: json['full_name_en'],
      email: json['email'],
      mobile: json['mobile'],
      role: json['role'],
      department: json['department'] != null
          ? DepartmentModel.fromJson(json['department'])
          : null,
      roleModel: json['role_model'] != null
          ? RoleModel.fromJson(json['role_model'])
          : null,
    );
  }

  final String id, username;
  final String fullNameAR, fullNameEN;
  final String email, mobile;
  final String? role;
  final DepartmentModel? department;
  final RoleModel? roleModel;

  UserEntity toDomain() {
    return UserEntity(
      id: id,
      username: username,
      fullNameAR: fullNameAR,
      fullNameEN: fullNameEN,
      email: email,
      mobile: mobile,
      rid: '',
      role: role ?? '',
      department: department != null
          ? DepartmentEntity.fromModel(department!)
          : null,
      roleEntity: roleModel != null ? RoleEntity.fromModel(roleModel!) : null,
    );
  }
}
