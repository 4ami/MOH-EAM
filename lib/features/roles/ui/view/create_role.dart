import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';
import 'package:moh_eam/features/roles/bloc/bloc.dart';
import 'package:moh_eam/features/roles/data/model/create_role.dart';
import 'package:moh_eam/features/roles/ui/widgets/role_selection.dart';

class CreateRoleWidget extends StatefulWidget {
  const CreateRoleWidget({super.key});

  @override
  State<CreateRoleWidget> createState() => _CreateRoleWidgetState();
}

class _CreateRoleWidgetState extends State<CreateRoleWidget> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final Map<String, Set<String>> _permissions = {};

  //field builder
  Widget _fieldBuilder({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    required void Function(String) onChanged,
    TextInputType? type,
    int? minLines,
    int? maxLines,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        keyboardType: type,
        minLines: minLines,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  List<Widget> _buildCheckboxes() {
    var a = context.read<AuthBloc>().state as AuthenticatedState;
    var resources = a.user.permissions.keys.toList();
    return List.generate(resources.length, (i) {
      setState(() {
        _permissions.putIfAbsent(resources[i], () => {});
      });
      return RoleSelection(
        resource: resources[i],
        actions: a.user.permissions[resources[i]] ?? [],
        permissions: _permissions[resources[i]]!,
        callback: (action, isSelected) {
          setState(() {
            if (!isSelected) {
              _permissions[resources[i]]!.remove(action);
              return;
            }
            _permissions[resources[i]]!.add(action);
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = context.watch<RoleBloc>().state;

    // late widgets initialization
    Widget nameField = _fieldBuilder(
      controller: _name,
      label: context.translate(key: 'name'),
      onChanged: (n) {},
      validator: (n) => ValidationHelper.name(n, context),
    );
    Widget descriptionField = _fieldBuilder(
      controller: _description,
      label: context.translate(key: 'description'),
      type: TextInputType.multiline,
      minLines: 5,
      maxLines: 5,
      onChanged: (d) {},
    );

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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              spacing: 15,
              children: [
                Text(
                  context.translate(key: 'add_new_role_title'),
                  style: context.h4,
                ),
                nameField,
                descriptionField,
                ..._buildCheckboxes(),

                ElevatedButton.icon(
                  onPressed: w.event is PendingRoleEvent ? null : _submit,
                  label: Text(context.translate(key: 'add_role_btn_label')),
                  icon: w.event is PendingRoleEvent
                      ? SizedBox(
                          width: 30,
                          height: 30,
                          child: const CircularProgressIndicator(),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _atLeastOneSelected(Map<String, List<String>> permissions) {
    for (var p in permissions.entries) {
      if (p.value.isNotEmpty) {
        return false;
      }
    }
    return true;
  }

  void _showError() {
    var t = context.translate;
    context.errorToast(
      title: t(key: 'role_failed_title_create'),
      description: t(key: 'must_select_at_least_one_permission'),
    );
  }

  void _submit() {
    final Map<String, List<String>> submittedPermissions = _permissions.map((
      k,
      v,
    ) {
      return MapEntry(k, v.toList());
    });

    if (_formKey.currentState?.validate() == true) {
      bool showError = _atLeastOneSelected(submittedPermissions);

      if (submittedPermissions.isEmpty || showError) {
        _showError();
        return;
      }

      var a = context.read<AuthBloc>().state as AuthenticatedState;
      var r = context.read<RoleBloc>();

      CreateRoleRequest request = CreateRoleRequest(
        name: _name.text.trim(),
        description: _description.text.trim(),
        permissions: submittedPermissions,
      );

      r.add(RoleCreateEvent(request: request, token: a.token));
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }
}
