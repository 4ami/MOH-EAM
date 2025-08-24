import 'package:moh_eam/core/data/model/base_response.dart';

final class RoleDeleteResponse extends BaseResponse {
  const RoleDeleteResponse({super.code, super.message, super.messageKey});

  factory RoleDeleteResponse.fromJSON(dynamic json) {
    return RoleDeleteResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
    );
  }
}
