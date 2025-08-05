part of 'users_widgets_module.dart';

class RoleSelector extends StatelessWidget {
  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.roles,
    required this.onSelect,
    this.exclude,
  });

  final String? exclude;
  final String selectedRole;
  final List<RoleEntity> roles;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    if (roles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ExpansionTile(
      title: Text(context.translate(key: 'select_role')),
      initiallyExpanded: true,
      children: roles.map((role) {
        if (role.id == exclude) return const SizedBox.shrink();
        final isSelected = selectedRole == role.id;
        return ListTile(
          title: Text(role.name),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: Colors.green)
              : null,
          onTap: () => onSelect(role.id),
        );
      }).toList(),
    );
  }
}
