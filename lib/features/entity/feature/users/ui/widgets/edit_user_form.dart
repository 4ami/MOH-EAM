part of 'users_widgets_module.dart';

class EditUserForm extends StatefulWidget {
  const EditUserForm({super.key, required this.user});

  final UserEntity user;

  @override
  State<EditUserForm> createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> {
  late final TextEditingController usernameCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController mobileCtrl;
  late final TextEditingController fullNameENCtrl;
  late final TextEditingController fullNameARCtrl;

  late String selectedRole;
  List<RoleEntity> availableRoles = [];

  @override
  void initState() {
    super.initState();
    usernameCtrl = TextEditingController(text: widget.user.username);
    emailCtrl = TextEditingController(text: widget.user.email);
    mobileCtrl = TextEditingController(text: widget.user.mobile);
    fullNameENCtrl = TextEditingController(text: widget.user.fullNameEN ?? '');
    fullNameARCtrl = TextEditingController(text: widget.user.fullNameAR ?? '');
    selectedRole = widget.user.role;
    availableRoles = context.read<GlobalDataBloc>().state.roles;
  }

  @override
  void dispose() {
    usernameCtrl.dispose();
    emailCtrl.dispose();
    mobileCtrl.dispose();
    fullNameENCtrl.dispose();
    fullNameARCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var auth = context.read<AuthBloc>().state as AuthenticatedState;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        // 👤 Username field
        EditableTextField(label: 'username', controller: usernameCtrl),

        // 📧 Email field
        EditableTextField(label: 'email', controller: emailCtrl),

        // 📱 Mobile field
        EditableTextField(label: 'mobile', controller: mobileCtrl),

        // 🧾 Full name (English)
        EditableTextField(label: 'full_name_en', controller: fullNameENCtrl),

        // 🧾 Full name (Arabic)
        EditableTextField(label: 'full_name_ar', controller: fullNameARCtrl),

        // 🧩 Role selector (ExpansionTile)
        RoleSelector(
          exclude: auth.user.rid,
          selectedRole: selectedRole,
          roles: availableRoles,
          onSelect: (val) {
            setState(() => selectedRole = val);
            Logger.d('Selected role: [$selectedRole]', tag: 'Edit User');
          },
        ),
        Row(
          spacing: 16,
          children: [
            Expanded(child: SaveButton(onPressed: _submit)),
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: context.error),
                  foregroundColor: context.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.cancel_rounded),
                label: Text(context.translate(key: 'cancel_action')),
                onPressed: () => context.pop(),
              ),
            ), // Make it as cancel button
          ],
        ),
      ],
    );
  }

  void _submit() {
    // Submit logic here
  }
}
