part of 'users_widgets_module.dart';

class EditUserForm extends StatefulWidget {
  const EditUserForm({super.key, required this.user});

  final UserEntity user;

  @override
  State<EditUserForm> createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController usernameCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController mobileCtrl;
  late final TextEditingController fullNameENCtrl;
  late final TextEditingController fullNameARCtrl;

  bool _isRightParent = false;

  String? rootId;
  String? currentSelectedId;

  Map<int, List<DepartmentEntity>> levelChildren = {};
  Map<int, String?> levelSelected = {};

  late String selectedRole;
  List<RoleEntity> availableRoles = [];

  @override
  void initState() {
    super.initState();
    usernameCtrl = TextEditingController(text: widget.user.username);
    emailCtrl = TextEditingController(text: widget.user.email);
    mobileCtrl = TextEditingController(
      text: widget.user.mobile.replaceAll('966', '0'),
    );
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

  void _departmentListener(BuildContext context, DepartmentState state) {
    if (state.event is DepartmentSuccessEvent) {
      setState(() {
        if (state.children.isNotEmpty) {
          int level = state.children[0].level;
          levelChildren[level] = state.children;
        }
      });
    }

    if (state.event is DepartmentAddedEvent) {
      context.successToast(
        title: context.translate(key: 'add_new_department'),
        description: context.translate(key: 'department_added_successfully'),
      );
      context.pop();
      return;
    }

    if (state.event is AddDepartmentFailedEvent) {
      context.errorToast(
        title: context.translate(key: 'department_adding_failed'),
        description: context.translate(key: state.event.message),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var auth = context.read<AuthBloc>().state as AuthenticatedState;
    var t = context.translate;
    var w = context.watch<UserEntityBloc>().state;
    var roots = context.read<GlobalDataBloc>().state.rootDepartments;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Form(
        key: _formKey,
        child: BlocListener<DepartmentBloc, DepartmentState>(
          listener: _departmentListener,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              // 👤 Username field
              EditableTextField(
                validator: (u) => ValidationHelper.username(u, context),
                label: 'username',
                controller: usernameCtrl,
              ),

              // 📧 Email field
              EditableTextField(
                validator: (e) => ValidationHelper.email(e, context),
                label: 'email',
                controller: emailCtrl,
              ),

              // 📱 Mobile field
              EditableTextField(
                validator: (m) => ValidationHelper.mobile(m, context),
                label: 'mobile',
                controller: mobileCtrl,
              ),

              // 🧾 Full name (English)
              EditableTextField(
                validator: (en) =>
                    ValidationHelper.fullName(en, context, isAr: false),
                label: 'full_name_en',
                controller: fullNameENCtrl,
              ),

              // 🧾 Full name (Arabic)
              EditableTextField(
                validator: (ar) =>
                    ValidationHelper.fullName(ar, context, isAr: true),
                label: 'full_name_ar',
                controller: fullNameARCtrl,
              ),

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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(t(key: 'department')),
                    Expanded(child: Divider()),
                  ],
                ),
              ),

              ...dynamicDepartment(roots),

              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: SaveButton(
                      icon: w.event is UserEntityLoadingEvent
                          ? SizedBox(
                              width: 30,
                              height: 30,
                              child: const CircularProgressIndicator(),
                            )
                          : null,
                      onPressed: w.event is UserEntityLoadingEvent
                          ? null
                          : _submit,
                    ),
                  ),
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
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() == true) {
      var usernameChanged = usernameCtrl.text.trim() != widget.user.username;
      var nameArChanged = fullNameARCtrl.text.trim() != widget.user.fullNameAR;
      var nameEnChanged = fullNameENCtrl.text.trim() != widget.user.fullNameEN;
      var emailChanged = emailCtrl.text.trim() != widget.user.email;
      var mobileChanged = mobileCtrl.text.trim() != widget.user.mobile;
      var roleChanged = selectedRole != widget.user.rid;
      var departmentChanged = currentSelectedId != widget.user.department?.id;
      PatchUserRequest request = PatchUserRequest(
        id: widget.user.id,
        username: usernameChanged ? usernameCtrl.text.trim() : null,
        nameAr: nameArChanged ? fullNameARCtrl.text.trim() : null,
        nameEn: nameEnChanged ? fullNameENCtrl.text.trim() : null,
        email: emailChanged ? emailCtrl.text.trim() : null,
        mobile: mobileChanged ? mobileCtrl.text.trim() : null,
        role: roleChanged ? selectedRole : null,
        department: departmentChanged ? currentSelectedId : null,
      );

      var a = context.read<AuthBloc>().state as AuthenticatedState;
      context.read<UserEntityBloc>().add(
        UpdateUserEvent(token: a.token, request: request),
      );
    }
  }

  List<Widget> dynamicDepartment(List<DepartmentEntity> roots) {
    return [
      // Root department dropdown
      Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<String>(
          value: rootId,
          isExpanded: true,
          decoration: InputDecoration(
            label: Text(
              context.translate(key: 'root_departments'),
              overflow: TextOverflow.fade,
              maxLines: 1,
            ),
            border: OutlineInputBorder(),
          ),
          items: roots
              .map(
                (r) => DropdownMenuItem(
                  value: r.id,
                  child: Text(r.name, overflow: TextOverflow.fade, maxLines: 1),
                ),
              )
              .toList(),
          onChanged: !_isRightParent
              ? (value) {
                  if (value == null) return;
                  setState(() {
                    rootId = value;
                    currentSelectedId = value;
                    levelChildren.clear();
                    levelSelected.clear();
                  });

                  var auth =
                      context.read<AuthBloc>().state as AuthenticatedState;
                  context.read<DepartmentBloc>().add(
                    DepartmentRequestChildren(
                      token: auth.token,
                      parent: rootId!,
                    ),
                  );
                }
              : null,
        ),
      ),

      // Add dynamic child dropdowns
      if (levelChildren.isNotEmpty) ...?_buildChildrenDropDown(),

      // Confirmation checkbox
      if (rootId != null)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CheckboxListTile(
            title: Text(context.translate(key: 'confirm_parent_department')),
            subtitle: Text(
              context.translate(key: 'confirm_parent_department_desc'),
            ),
            value: _isRightParent,
            onChanged: (value) {
              setState(() {
                _isRightParent = value ?? false;

                // Remove unselected deeper dropdowns when confirmed
                if (_isRightParent) {
                  levelChildren.removeWhere((level, d) {
                    return levelSelected[level] == null ||
                        levelSelected[level]!.isEmpty;
                  });
                }
              });
            },
          ),
        ),
    ];
  }

  List<Widget>? _buildChildrenDropDown() {
    return levelChildren.entries.map((e) {
      final level = e.key;
      final departments = e.value;
      if (departments.isEmpty) return SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<String>(
          value: levelSelected[level],
          decoration: InputDecoration(
            labelText: context
                .translate(key: 'sub_departments_level')
                .replaceAll('\$level', level.toString()),
            border: OutlineInputBorder(),
          ),
          items: departments
              .map(
                (dept) => DropdownMenuItem<String>(
                  value: dept.id,
                  child: Text(dept.name),
                ),
              )
              .toList(),
          onChanged: !_isRightParent
              ? (v) {
                  if (v == null) return;
                  setState(() {
                    // Update selection at this level
                    levelSelected[level] = v;

                    // Track last selected department id
                    currentSelectedId = v;

                    // Remove deeper levels
                    levelChildren.removeWhere((k, v) => k > level);
                    levelSelected.removeWhere((k, v) => k > level);
                  });

                  // Fetch next level children
                  var auth =
                      context.read<AuthBloc>().state as AuthenticatedState;
                  context.read<DepartmentBloc>().add(
                    DepartmentRequestChildren(token: auth.token, parent: v),
                  );
                }
              : null,
        ),
      );
    }).toList();
  }
}
