import 'package:moh_eam/core/domain/entity/entity_model.dart';
import 'package:moh_eam/features/entity/feature/users/domain/entity/user_entity.dart';

class DeviceEntity extends EntityModel {
  final String id, serial, model, type;
  final String? hostName;
  final bool? inDomain, kasperInstalled, crowdStrikeInstalled;
  final UserEntity? user;
  const DeviceEntity({
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

  @override
  String get resourceName => 'devices';

  @override
  List<String> get columns => [
    'id',
    'serial',
    'model',
    'type',
    'host_name',
    'is_in_domain?',
    'is_kasper_installed?',
    'is_crowdstrike_installed?',
    if (user != null) ...user?.columns ?? <String>[],
  ];

  static List<String> get tableCols => [
    'id',
    'serial',
    'model',
    'type',
    'host_name',
    'is_in_domain?',
    'is_kasper_installed?',
    'is_crowdstrike_installed?',
    ...UserEntity.tableCols,
  ];

  @override
  List<String> get props => [
    'id',
    'serial',
    'model',
    'type',
    'host_name',
    'in_domain',
    'kasper_installed',
    'crowd_strike_installed',
    'user',
  ];

  @override
  Map<String, dynamic> toTableRow() {
    return {
      'id': id,
      'serial': serial,
      'model': model,
      'type': type,
      'host_name': hostName ?? '',
      'is_in_domain?': inDomain ?? false,
      'is_kasper_installed?': kasperInstalled ?? false,
      'is_crowdstrike_installed?': crowdStrikeInstalled ?? false,
      if (user != null) ...user!.toTableRow(),
    };
  }
}
