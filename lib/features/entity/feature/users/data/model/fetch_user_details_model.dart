import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/auth/data/models/user_model.dart';

class FetchUserDetailsModel extends BaseResponse {
  const FetchUserDetailsModel({
    super.code,
    super.message,
    super.messageKey,
    this.user,
  });

  final UserModel? user;

  factory FetchUserDetailsModel.fromJSON(dynamic json) {
    return FetchUserDetailsModel(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      user: UserModel.fromJSON(json['user']),
    );
  }
}
