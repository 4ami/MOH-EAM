import 'package:moh_eam/core/data/model/base_response.dart';

final class DeleteUserResponse extends BaseResponse {
  const DeleteUserResponse({super.code, super.message, super.messageKey});

  factory DeleteUserResponse.fromJSON(dynamic json) {
    return DeleteUserResponse(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
    );
  }
}
