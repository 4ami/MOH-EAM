import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/auth/data/models/user_model.dart';
import 'package:moh_eam/features/entity/feature/devices/data/model/device.dart';

class GlobalSearchResponse extends BaseResponse {
  const GlobalSearchResponse({
    super.code,
    super.message,
    super.messageKey,
    this.users = const [],
    this.devices = const [],
  });

  final List<UserModel> users;
  final List<DeviceModel> devices;

  factory GlobalSearchResponse.fromJSON(dynamic json) {
    return GlobalSearchResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      users: List.generate(
        json['matchs']['users'].length,
        (i) => UserModel.fromJSON(json['matchs']['users'][i]),
      ),
      devices: List.generate(
        json['matchs']['devices'].length,
        (i) => DeviceModel.fromJSON(json['matchs']['devices'][i]),
      ),
    );
  }
}
