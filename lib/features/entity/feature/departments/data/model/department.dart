import 'package:moh_eam/features/entity/feature/departments/domain/entity/department.dart';

class DepartmentModel {
  final int code;
  final String message, messageKey;

  final String id, name, levelName;
  final String? parentId;
  final int level;
  final Map<String, dynamic>? extra;

  const DepartmentModel({
    required this.code,
    required this.message,
    required this.messageKey,
    required this.id,
    required this.name,
    required this.levelName,
    required this.level,
    this.parentId,
    this.extra,
  });

  factory DepartmentModel.fromJson(dynamic json) {
    return DepartmentModel(
      code: json['code'] ?? -1,
      message: json['message'] ?? '',
      messageKey: json['message_key'] ?? '',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      levelName: json['level_name'],
      level: json['level'] ?? 0,
      parentId: json['parent_id'],
      extra: json['extra'] ?? {},
    );
  }

  DepartmentEntity toDomain() {
    return DepartmentEntity(
      id: id,
      name: name,
      levelName: levelName,
      level: level,
      parentId: parentId,
      extra: extra
    );
  }
}
