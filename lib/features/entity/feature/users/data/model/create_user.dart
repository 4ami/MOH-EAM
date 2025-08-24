import 'package:moh_eam/core/data/model/base_request.dart';
import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/auth/data/models/user_model.dart';
import 'package:moh_eam/features/entity/feature/users/domain/entity/user_entity.dart';

final class CreateUserRequest extends BaseRequest {
  const CreateUserRequest({required this.user, required this.password});

  final UserEntity user;
  final String password;
  @override
  Map<String, dynamic> toJson() {
    return {
      "username": user.username,
      "full_name_ar": user.fullNameAR,
      "full_name_en": user.fullNameEN,
      "email": user.email,
      "mobile": user.mobile,
      "role": user.role,
      if (user.department != null) "department": user.department?.id,
      "password": password,
    };
  }
}

final class CreateUserResponse extends BaseResponse {
  const CreateUserResponse({
    super.code,
    super.message,
    super.messageKey,
    this.user,
  });

  final UserModel? user;

  factory CreateUserResponse.fromJSON(dynamic json) {
    return CreateUserResponse(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      user: UserModel.fromJSON(json['user']),
    );
  }
}
