import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/auth/data/models/user_model.dart';

final class FetchUsersModel extends BaseResponse {
  const FetchUsersModel({
    super.message,
    super.messageKey,
    super.code,
    required this.users,
    this.total
  });

  final List<UserModel> users;
  final int? total;

  factory FetchUsersModel.fromJSON(dynamic json) {
    return FetchUsersModel(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      total: json['total'],
      users: List.generate(
        json['users'].length,
        (i) => UserModel.fromJSON(json['users'][i]),
      ),
    );
  }
}
