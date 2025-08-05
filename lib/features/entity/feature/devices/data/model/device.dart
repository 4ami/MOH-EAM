import 'package:moh_eam/features/entity/feature/devices/domain/entity/device.dart';
import 'package:moh_eam/features/auth/data/models/user_model.dart';

class DeviceModel {
  final String id, serial, model, type;
  final String? hostName;
  final bool? inDomain, kasperInstalled, crowdStrikeInstalled;
  final UserModel? user;

  const DeviceModel({
    required this.id,
    required this.serial,
    required this.model,
    required this.type,
    this.hostName,
    this.inDomain,
    this.kasperInstalled,
    this.crowdStrikeInstalled,
    this.user,
  });

  factory DeviceModel.fromJSON(dynamic json) {
    return DeviceModel(
      id: json['id'],
      serial: json['serial'],
      model: json['model'],
      type: json['type'],
      hostName: json['host_name'],
      inDomain: json['in_domain'],
      kasperInstalled: json['kasper_installed'],
      crowdStrikeInstalled: json['crowdstrike_installed'],
      user: json['user'] != null ? UserModel.fromJSON(json['user']) : null,
    );
  }

  DeviceEntity toDomain() {
    return DeviceEntity(
      id: id,
      serial: serial,
      model: model,
      type: type,
      hostName: hostName,
      inDomain: inDomain,
      kasperInstalled: kasperInstalled,
      crowdStrikeInstalled: crowdStrikeInstalled,
      user: user?.toDomain(),
    );
  }
}
