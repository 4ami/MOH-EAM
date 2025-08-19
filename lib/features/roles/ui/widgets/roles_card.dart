part of 'widgets_module.dart';

class RolesCard extends StatelessWidget {
  const RolesCard({super.key, required this.role});
  final RoleEntity role;

  @override
  Widget build(BuildContext context) {
    var w = context.watch<RoleBloc>().state;
    bool canDelete = AuthorizationHelper.hasMinimumPermission(
      context,
      'roles',
      'DELETE',
    );
    return Container(
      padding: EdgeInsets.all(context.padding),
      margin: EdgeInsets.symmetric(vertical: 15),
      width: context.responsive.width(.6),
      decoration: _boxDecoration(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),

          /// ID
          _info(context, 'id', role.id),
          // Role name
          _info(context, 'role', role.name),
          // Role description
          _info(context, 'description', role.description),
          // Role Permissions
          __permissions(context),

          EntityActions(
            hasEdit: false,
            hasDelete: canDelete,
            onDelete: w.event is PendingRoleEvent? null : () => _onDelete(context),
            onEdit: null,
          ),
        ],
      ),
    );
  }

  Padding __permissions(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 8),
      child: Column(
        children: [
          const Divider(),
          Text(
            context.translate(key: 'permissions'),
            style: context.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
          ),
          const Divider(),
          Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: role.permissions.entries.map((e) {
              return ExpansionItemOfList(title: e.key, list: e.value);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Row _info(BuildContext context, String key, String? val) {
    bool nullable = val == null || val.isEmpty;
    String value = nullable ? 'NA' : val;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          '${context.translate(key: key)}:',
          style: context.titleMedium!.copyWith(
            decoration: nullable ? TextDecoration.lineThrough : null,
          ),
          textScaler: TextScaler.linear(.8),
        ),
        Expanded(
          child: SelectableText(value, textScaler: TextScaler.linear(.8)),
        ),
      ],
    );
  }

  void _onDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.translate(key: 'delete_confirmation_title')),
        content: Text(context.translate(key: 'delete_confirmation_message')),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(context.translate(key: 'cancel_action')),
          ),
          TextButton(
            onPressed: () {
              var a = context.read<AuthBloc>().state as AuthenticatedState;
              context.read<RoleBloc>().add(
                RoleDeleteEvent(token: a.token, id: role.id),
              );
            },
            child: Text(
              context.translate(key: 'delete_action'),
              style: context.bodyLarge!.copyWith(color: context.error),
            ),
          ),
        ],
      ),
    );
  }

  Text _header(BuildContext context) {
    return Text(
      context.translate(key: '${role.resourceName}_card_title'),
      style: context.titleLarge!.copyWith(fontWeight: FontWeight.bold),
      textScaler: TextScaler.linear(.5),
    );
  }

  BoxDecoration _boxDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [context.surface, context.surfaceDim],
      ),
      boxShadow: [
        BoxShadow(
          color: context.shadow.withAlpha(50),
          blurRadius: 10,
          offset: const Offset(0, 2),
          spreadRadius: -2,
        ),
      ],
    );
  }
}
