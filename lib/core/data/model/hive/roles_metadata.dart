import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class HiveRolesMetadataModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String role;
  @HiveField(2)
  final Map<String, List<String>> permissions;
  @HiveField(3)
  final DateTime lastUpdate;

  HiveRolesMetadataModel({
    required this.id,
    required this.role,
    required this.permissions,
    required this.lastUpdate,
  });

  
}
