import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/entity/feature/devices/data/model/device.dart';

class FetchDevicesResponse extends BaseResponse {
  final List<DeviceModel> devices;
  final int max;
  const FetchDevicesResponse({
    super.code,
    super.message,
    super.messageKey,
    required this.devices,
    required this.max,
  });

  factory FetchDevicesResponse.fromJSON(dynamic json) {
    return FetchDevicesResponse(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      max: json['max'] ?? 0,
      devices: List.generate(
        json['devices'].length,
        (i) => DeviceModel.fromJSON(json['devices'][i]),
      ),
    );
  }
}
