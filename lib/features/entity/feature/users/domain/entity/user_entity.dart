import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:moh_eam/core/domain/entity/entity_model.dart';
import 'package:moh_eam/features/auth/domain/entities/role.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/entity/department.dart';

class UserEntity extends EntityModel {
  const UserEntity({
    required this.id,
    this.fullNameAR,
    this.fullNameEN,
    required this.username,
    required this.email,
    required this.mobile,
    required this.role,
    required this.rid,
    this.permissions = const {},
    this.department,
    this.roleEntity,
  });

  final String id, username;
  final String? fullNameAR, fullNameEN;
  final String email, mobile;
  final String rid, role;
  final Map<String, List<String>> permissions;
  final DepartmentEntity? department;
  final RoleEntity? roleEntity;

  static List<String> get tableCols => [
    'id',
    'username',
    'email',
    'mobile',
    'full_name_ar',
    'full_name_en',
  ];

  @override
  String get resourceName => 'users';

  @override
  List<String> get columns => [
    'id',
    'username',
    'email',
    'mobile',
    'full_name_ar',
    'full_name_en',
  ];

  @override
  List<String> get props => [
    'id',
    'username',
    'email',
    'mobile',
    'full_name_ar',
    'full_name_en',
    'role',
    'permissions',
    'department',
  ];

  @override
  Map<String, dynamic> toTableRow() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'mobile': mobile,
      'full_name_ar': fullNameAR ?? '',
      'full_name_en': fullNameEN ?? '',
      if (roleEntity == null) ...{'role': role, 'permissions': permissions},
      if (roleEntity != null) ...{
        'role': roleEntity!.name,
        'permissions': roleEntity!.permissions,
      },
      if (department != null) 'department': department?.toTableRow(),
    };
  }

  factory UserEntity.fromToken({required String token}) {
    var decoded = JwtDecoder.decode(token);
    Map<String, dynamic> permissions =
        decoded['permissions'] as Map<String, dynamic>;

    return UserEntity(
      id: decoded['_id'],
      username: decoded['username'],
      fullNameAR: decoded['full_name'],
      fullNameEN: decoded['full_name'],
      email: decoded['email'],
      mobile: decoded['mobile'],
      role: decoded['role'] ?? '',
      rid: decoded['rid'] ?? '',
      permissions: permissions.map(
        (k, v) => MapEntry(k, List<String>.from(v as List)),
      ),
    );
  }
}
