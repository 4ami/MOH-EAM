import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/core/bloc/global_bloc_module.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';
import 'package:moh_eam/features/auth/domain/entities/role.dart';
import 'package:moh_eam/features/entity/feature/departments/bloc/bloc.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/entity/department.dart';
import 'package:moh_eam/features/entity/feature/users/bloc/bloc.dart';
import 'package:moh_eam/features/entity/feature/users/domain/entity/user_entity.dart';

class CreateUserWidget extends StatefulWidget {
  const CreateUserWidget({super.key});

  @override
  State<CreateUserWidget> createState() => _CreateUserWidgetState();
}

class _CreateUserWidgetState extends State<CreateUserWidget> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _fullNameARController = TextEditingController();
  final _fullNameENController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _generatedPasswordController = TextEditingController();

  String? _selectedRole;
  bool _useRandomPassword = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isRightParent = false;

  String? rootId;
  String? currentSelectedId;

  DepartmentEntity? selectedDept;

  Map<int, List<DepartmentEntity>> levelChildren = {};
  Map<int, String?> levelSelected = {};

  @override
  Widget build(BuildContext context) {
    var gdb = context.read<GlobalDataBloc>().state;
    var auth = context.read<AuthBloc>().state as AuthenticatedState;
    var w = context.watch<UserEntityBloc>().state;
    List<RoleEntity> roles = gdb.roles
        .where((r) => r.id != auth.user.rid)
        .toList();
    var t = context.translate;
    var roots = context.read<GlobalDataBloc>().state.rootDepartments;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<DepartmentBloc, DepartmentState>(
            listener: _departmentListener,
          ),
        ],
        child: Container(
          padding: EdgeInsets.all(25),
          margin: EdgeInsets.only(
            left: context.responsive.padding,
            right: context.responsive.padding,
            bottom: MediaQuery.viewInsetsOf(context).bottom + 25,
            top: MediaQuery.viewInsetsOf(context).top + 25,
          ),
          decoration: BoxDecoration(
            color: context.surface,
            borderRadius: BorderRadius.circular(
              context.responsive.borderRadius,
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildField(
                    required: true,
                    controller: _usernameController,
                    label: context.translate(key: 'username'),
                    validator: (u) => ValidationHelper.username(u, context),
                    onChanged: (u) {},
                  ),

                  _buildField(
                    required: true,
                    controller: _fullNameARController,
                    label: context.translate(key: 'full_name_ar'),
                    validator: (n) =>
                        ValidationHelper.fullName(n, context, isAr: true),
                    onChanged: (n) {},
                  ),

                  _buildField(
                    required: true,
                    controller: _fullNameENController,
                    label: context.translate(key: 'full_name_en'),
                    validator: (n) =>
                        ValidationHelper.fullName(n, context, isAr: false),
                    onChanged: (n) {},
                  ),

                  _buildField(
                    required: true,
                    controller: _emailController,
                    label: context.translate(key: 'email'),
                    type: TextInputType.emailAddress,
                    validator: (e) => ValidationHelper.email(e, context),
                    onChanged: (v) {},
                  ),

                  _buildField(
                    hint: '05XXXXXXXX',
                    required: true,
                    controller: _mobileController,
                    label: context.translate(key: 'mobile'),
                    type: TextInputType.phone,
                    validator: (m) => ValidationHelper.mobile(m, context),
                    onChanged: (m) {},
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: InputDecoration(
                        labelText: context.translate(key: 'role'),
                        border: OutlineInputBorder(),
                      ),
                      items: roles
                          .map(
                            (role) => DropdownMenuItem(
                              value: role.id,
                              child: Text(role.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedRole = value),
                    ),
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CheckboxListTile(
                      title: Text(
                        context.translate(
                          key: 'generate_password_checkbox_label',
                        ),
                      ),
                      value: _useRandomPassword,
                      onChanged: (value) {
                        setState(() {
                          _useRandomPassword = value ?? false;
                          if (_useRandomPassword) {
                            _generateRandomPassword();
                          }
                        });
                      },
                    ),
                  ),

                  if (_useRandomPassword) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextFormField(
                        controller: _generatedPasswordController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: context.translate(
                            key: 'generated_password_value_field',
                          ),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () => Clipboard.setData(
                              ClipboardData(
                                text: _generatedPasswordController.text,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    _buildField(
                      controller: _passwordController,
                      label: context.translate(key: 'signin_password_label'),
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                      validator: (p) => ValidationHelper.password(p, context),
                      onChanged: (p) {},
                    ),

                    _buildField(
                      controller: _confirmPasswordController,
                      label: context.translate(
                        key: 'confirm_password_field_label',
                      ),
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        ),
                      ),
                      validator: (cp) => ValidationHelper.confirmPassword(
                        cp,
                        _passwordController.text,
                        context,
                      ),
                      onChanged: (cp) {},
                    ),
                  ],

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: w.event is UserEntityLoadingEvent
                          ? null
                          : _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      label: Text(context.translate(key: 'add_user_btn')),
                      icon: w.event is UserEntityLoadingEvent
                          ? SizedBox(
                              width: 30,
                              height: 30,
                              child: const CircularProgressIndicator(),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
                    selectedDept = roots.where((r) => r.id == value).first;
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
                    selectedDept = departments.where((r) => r.id == v).first;
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

  void _submitForm() {
    if (_formKey.currentState?.validate() == true) {
      var user = UserEntity(
        id: '',
        fullNameAR: _fullNameARController.text.trim(),
        fullNameEN: _fullNameENController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        mobile: "966${_mobileController.text.trim().substring(1)}",
        role: _selectedRole ?? '',
        rid: _selectedRole ?? '',
        department: selectedDept != null
            ? selectedDept!.id == currentSelectedId
                  ? selectedDept
                  : null
            : null,
      );

      String password = '';
      if (_useRandomPassword) {
        password = _generatedPasswordController.text.trim();
      } else {
        password = _confirmPasswordController.text.trim();
      }

      var a = context.read<AuthBloc>().state as AuthenticatedState;
      var u = context.read<UserEntityBloc>();

      u.add(CreateUserEvent(token: a.token, user: user, password: password));
    }
  }

  void _generateRandomPassword() {
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const special = '!@#\$%^&*()_+-=[]{};\'":\\|,.<>/?`~';

    final random = Random();
    List<String> password = [];

    // Ensure at least one from each required category
    password.add(lowercase[random.nextInt(lowercase.length)]);
    password.add(uppercase[random.nextInt(uppercase.length)]);
    password.add(numbers[random.nextInt(numbers.length)]);
    password.add(numbers[random.nextInt(numbers.length)]); // At least 2 digits
    password.add(special[random.nextInt(special.length)]);

    // Fill remaining positions with random characters from all categories
    const allChars = lowercase + uppercase + numbers + special;
    for (int i = password.length; i < 12; i++) {
      password.add(allChars[random.nextInt(allChars.length)]);
    }

    // Shuffle the password to randomize positions
    password.shuffle(random);

    _generatedPasswordController.text = password.join();
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? Function(String?)? validator,
    required void Function(String) onChanged,
    TextInputType? type,
    Widget? suffixIcon,
    bool obscureText = false,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        keyboardType: type,
        obscureText: obscureText,
        decoration: InputDecoration(
          label: required ? _requiredField(label) : null,
          labelText: required ? null : label,
          hintText: hint,
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  Widget _requiredField(String label) {
    return RichText(
      text: TextSpan(
        text: label,
        style: context.labelLarge,
        children: [
          TextSpan(
            text: ' *',
            style: context.labelLarge!.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
