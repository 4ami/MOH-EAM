import 'package:moh_eam/core/data/model/base_response.dart';

class DeleteDepartmentResponse extends BaseResponse {
  const DeleteDepartmentResponse({super.code, super.message, super.messageKey});

  factory DeleteDepartmentResponse.fromJSON(dynamic json) {
    return DeleteDepartmentResponse(
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      code: json['code'] ?? -1,
    );
  }
}
