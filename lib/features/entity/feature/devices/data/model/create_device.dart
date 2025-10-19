import 'package:moh_eam/core/data/model/base_request.dart';
import 'package:moh_eam/core/data/model/base_response.dart';
import 'package:moh_eam/features/entity/feature/devices/data/model/device.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/entity/device.dart';

class CreateDeviceRequest extends BaseRequest {
  final DeviceEntity device;
  final String movementState;
  final String? note;
  const CreateDeviceRequest({
    required this.device,
    required this.movementState,
    this.note,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "serial": device.serial,
      "model": device.model,
      "type": device.type,
      if (device.hostName != null) "host_name": device.hostName,
      if (device.inDomain != null) "in_domain": device.inDomain,
      if (device.kasperInstalled != null)
        "kasper_installed": device.kasperInstalled,
      if (device.crowdStrikeInstalled != null)
        "crowdstrike_installed": device.crowdStrikeInstalled,
      if (device.user != null) "user": device.user!.id,
      "device_state": movementState,
      if (note != null) "action_note": note,
    };
  }
}

class CreateDeviceResponse extends BaseResponse {
  final DeviceModel device;
  const CreateDeviceResponse({
    super.code,
    super.message,
    super.messageKey,
    required this.device,
  });

  factory CreateDeviceResponse.fromJSON(dynamic json) {
    return CreateDeviceResponse(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      device: DeviceModel.fromJSON(json['device_info']),
    );
  }
}
