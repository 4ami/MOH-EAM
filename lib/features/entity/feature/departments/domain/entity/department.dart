import 'package:moh_eam/core/domain/entity/entity_model.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/department.dart';

class DepartmentEntity extends EntityModel {
  const DepartmentEntity({
    required this.id,
    required this.name,
    required this.levelName,
    required this.level,
    this.parentId,
    this.extra,
  });

  final String id, name, levelName;
  final String? parentId;
  final int level;
  final Map<String, dynamic>? extra;

  @override
  String get resourceName => 'departmenta';

  @override
  List<String> get columns => ['id', 'dept_name', 'level_name'];

  @override
  List<String> get props => [
    'id',
    'name',
    'level_name',
    'level',
    'parent_id',
    'extra',
  ];

  @override
  Map<String, dynamic> toTableRow() {
    return {
      'id': id,
      'name': name,
      'level_name': levelName,
      'level': level,
      if (parentId != null) 'parent_id': parentId,
      if (extra != null) 'extra': extra,
    };
  }

  factory DepartmentEntity.fromModel(DepartmentModel model) {
    return DepartmentEntity(
      id: model.id,
      name: model.name,
      levelName: model.levelName,
      level: model.level,
      parentId: model.parentId,
      extra: model.extra,
    );
  }
}
