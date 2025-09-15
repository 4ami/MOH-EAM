import 'package:moh_eam/core/data/model/base_response.dart';

final class DeleteDeviceResponse extends BaseResponse {
  const DeleteDeviceResponse({super.code, super.message, super.messageKey});

  factory DeleteDeviceResponse.fromJSON(dynamic json) {
    return DeleteDeviceResponse(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
    );
  }
}
