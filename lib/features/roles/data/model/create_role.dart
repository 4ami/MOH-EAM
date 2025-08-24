import 'package:moh_eam/core/data/model/base_request.dart';
import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/auth/data/models/roles.dart';

final class CreateRoleRequest extends BaseRequest {
  final String name;
  final String? description;
  final Map<String, List<String>> permissions;
  final List<String>? users;

  const CreateRoleRequest({
    required this.name,
    this.description,
    required this.permissions,
    this.users,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "role_name": name,
      if (description != null) "role_description": description,
      "permissions": permissions,
      if (users != null) "users": users,
    };
  }
}

final class CreateRoleResponse extends BaseResponse {
  final RoleModel role;
  const CreateRoleResponse({
    super.code,
    super.message,
    super.messageKey,
    required this.role,
  });

  factory CreateRoleResponse.fromJSON(dynamic json) {
    return CreateRoleResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      role: RoleModel.fromJson(json['role']),
    );
  }
}
