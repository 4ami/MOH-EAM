import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/core/bloc/global_bloc_module.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';
import 'package:moh_eam/features/auth/domain/entities/role.dart';

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

  @override
  Widget build(BuildContext context) {
    var gdb = context.read<GlobalDataBloc>().state;
    var auth = context.read<AuthBloc>().state as AuthenticatedState;
    List<RoleEntity> roles = gdb.roles
        .where((r) => r.id != auth.user.rid)
        .toList();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
          borderRadius: BorderRadius.circular(context.responsive.borderRadius),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildField(
                  controller: _usernameController,
                  label: context.translate(key: 'username'),
                  validator: (u) => ValidationHelper.username(u, context),
                  onChanged: (u) {},
                ),

                _buildField(
                  controller: _fullNameARController,
                  label: context.translate(key: 'full_name_ar'),
                  validator: (n) => ValidationHelper.fullName(n, context),
                  onChanged: (n) {},
                ),

                _buildField(
                  controller: _fullNameENController,
                  label: context.translate(key: 'full_name_en'),
                  validator: (n) => ValidationHelper.fullName(n, context),
                  onChanged: (n) {},
                ),

                _buildField(
                  controller: _emailController,
                  label: context.translate(key: 'email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (e) => ValidationHelper.email(e, context),
                  onChanged: (v) {},
                ),

                _buildField(
                  controller: _mobileController,
                  label: context.translate(key: 'mobile'),
                  keyboardType: TextInputType.phone,
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
                    onChanged: (value) => setState(() => _selectedRole = value),
                  ),
                ),

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
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
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
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                    ),
                    validator: (cp) => ValidationHelper.confirmPassword(
                      cp,
                      _passwordController.text,
                      context,
                    ),
                    onChanged: (cp) {},
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          context.translate(key: 'add_user_btn'),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() == true) {
      /// TODO:
      // var user = UserEntity(
      //   id: '',
      //   username: _usernameController.text.trim(),
      //   email: _emailController.text.trim(),
      //   mobile: "966${_mobileController.text.trim()}",
      //   role: _selectedRole ?? '',
      //   rid: _selectedRole ?? '',
      // );
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
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    required void Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon,
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
