import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/auth/data/models/roles.dart';

final class FetchRolesResponse extends BaseResponse {
  final List<RoleModel> roles;
  const FetchRolesResponse({
    super.code,
    super.message,
    super.messageKey,
    required this.roles,
  });

  factory FetchRolesResponse.fromJSON(dynamic json) {
    return FetchRolesResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      roles: List.generate(
        json['roles'].length,
        (i) => RoleModel.fromJson(json['roles'][i]),
      ),
    );
  }
}
