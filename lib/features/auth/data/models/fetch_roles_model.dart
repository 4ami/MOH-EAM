import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/auth/data/models/roles.dart';

final class FetchRolesModel extends BaseResponse {
  final List<RoleModel> roles;

  const FetchRolesModel({
    super.code,
    super.message,
    super.messageKey = 'general_error_message',
    required this.roles,
  });

  factory FetchRolesModel.fromJson(Map<String, dynamic> json) {
    return FetchRolesModel(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      roles: (json['roles'] as List<dynamic>)
          .map((role) => RoleModel.fromJson(role as Map<String, dynamic>))
          .toList(),
    );
  }
}
