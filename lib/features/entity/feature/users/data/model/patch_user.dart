import 'package:moh_eam/core/data/model/base_request.dart';
import 'package:moh_eam/core/data/model/base_response.dart';

final class PatchUserRequest extends BaseRequest {
  final String id;
  final String? nameAr, nameEn, email, mobile, username, role, department;

  const PatchUserRequest({
    required this.id,
    this.username,
    this.nameAr,
    this.nameEn,
    this.email,
    this.mobile,
    this.role,
    this.department,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      if (username != null) "username": username,
      if (nameAr != null) "full_name_ar": nameAr,
      if (nameEn != null) "full_name_en": nameEn,
      if (email != null) "email": email,
      if (mobile != null) "mobile": mobile,
      if (role != null) "role": role,
      if (department != null) "department": department,
    };
  }
}

final class PatchUserResponse extends BaseResponse {
  const PatchUserResponse({super.code, super.message, super.messageKey});

  factory PatchUserResponse.fromJSON(dynamic json) {
    return PatchUserResponse(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
    );
  }
}
