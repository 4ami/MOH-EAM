import 'package:moh_eam/core/domain/entity/entity_model.dart';
import 'package:moh_eam/features/auth/data/models/roles.dart';

class RoleEntity extends EntityModel {
  final String id, name;
  final String? description;
  final Map<String, List<String>> permissions;

  const RoleEntity({
    required this.id,
    required this.name,
    this.description = '',
    required this.permissions,
  });

  @override
  List<String> get props => ['id', 'name', 'description', 'permissions'];

  @override
  List<String> get columns => ['id', 'name', 'description', 'permissions'];

  @override
  String get resourceName => 'roles';

  @override
  Map<String, dynamic> toTableRow() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'permissions': permissions,
    };
  }

  factory RoleEntity.fromModel(RoleModel model) {
    return RoleEntity(
      id: model.id,
      name: model.name,
      permissions: model.permissions,
    );
  }
}
