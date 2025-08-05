import 'package:moh_eam/features/auth/domain/entities/role.dart';

class RoleModel {
  final String id;
  final String name;
  final String? description;
  final Map<String, List<String>> permissions;

  RoleModel({
    required this.id,
    required this.name,
    this.description,
    required this.permissions,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      permissions: (json['permissions'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }

  RoleEntity toDomain() {
    return RoleEntity(
      id: id,
      name: name,
      description: description,
      permissions: permissions,
    );
  }
}
