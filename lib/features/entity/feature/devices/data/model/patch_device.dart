import 'package:moh_eam/core/data/model/base_request.dart';
import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/entity/device.dart';

class PatchDeviceRequest extends BaseRequest {
  final DeviceEntity device;
  const PatchDeviceRequest({required this.device});

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": device.id,
      if (device.serial.isNotEmpty) "serial": device.serial,
      if (device.model.isNotEmpty) "model": device.model,
      if (device.type.isNotEmpty) "type": device.type,
      if (device.hostName != null) "host_name": device.hostName,
      if (device.inDomain != null) "in_domain": device.inDomain,
      if (device.kasperInstalled != null)
        "kasper_installed": device.kasperInstalled,
      if (device.crowdStrikeInstalled != null)
        "crowdstrike_installed": device.crowdStrikeInstalled,
      if (device.user != null) "user": device.user!.id,
    };
  }
}

class PatchDeviceResponse extends BaseResponse {
  const PatchDeviceResponse({super.code, super.message, super.messageKey});

  factory PatchDeviceResponse.fromJSON(dynamic json) {
    return PatchDeviceResponse(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
    );
  }
}
