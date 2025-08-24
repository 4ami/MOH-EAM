import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/core/bloc/global_bloc_module.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';
import 'package:moh_eam/features/entity/feature/departments/bloc/bloc.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/create_department.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/entity/department.dart';

class CreateDepartmentWidget extends StatefulWidget {
  const CreateDepartmentWidget({super.key});

  @override
  State<CreateDepartmentWidget> createState() => _CreateDepartmentWidgetState();
}

class _CreateDepartmentWidgetState extends State<CreateDepartmentWidget> {
  final _formKey = GlobalKey<FormState>();

  final _nameARController = TextEditingController();
  final _nameENController = TextEditingController();
  final _levelNameController = TextEditingController();

  Map<int, List<DepartmentEntity>> levelChildren = {};
  Map<int, String?> levelSelected = {};

  String? parentId;
  String? rootId;
  String? selectedSubParent;

  bool _isRoot = false;
  bool _isRightParent = false;

  @override
  Widget build(BuildContext context) {
    var roots = context.read<GlobalDataBloc>().state.rootDepartments;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocListener<DepartmentBloc, DepartmentState>(
        listener: _departmentListener,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildField(
                    controller: _nameARController,
                    label: context.translate(key: 'name_ar'),
                    validator: (ar) =>
                        ValidationHelper.fullName(ar, context, isAr: true),
                    onChanged: (n) {
                      //  Handle name AR changes if needed
                    },
                  ),

                  _buildField(
                    controller: _nameENController,
                    label: context.translate(key: 'name_en'),
                    validator: (en) =>
                        ValidationHelper.fullName(en, context, isAr: false),
                    onChanged: (n) {
                      //  Handle name EN changes if needed
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CheckboxListTile(
                      title: Text(context.translate(key: 'is_root_department')),
                      value: _isRoot,
                      onChanged: (value) {
                        setState(() {
                          _isRoot = value ?? false;
                          if (!_isRoot) {
                            parentId = null;
                            //  Load root departments for selection
                          } else {
                            //  Clear department selection
                            selectedSubParent = null;
                            levelChildren.clear();
                            levelSelected.clear();
                          }
                        });
                      },
                    ),
                  ),

                  _buildField(
                    controller: _levelNameController,
                    validator: (ln) =>
                        ValidationHelper.fullName(ln, context, isAr: null),
                    label: context.translate(key: 'level_name'),
                    onChanged: (n) {
                      //  Handle level name changes if needed
                    },
                  ),
                  if (!_isRoot) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: DropdownButtonFormField<String>(
                        validator: (v) => ValidationHelper.dropDown(v, context),
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
                        items: List.generate(roots.length, (i) {
                          return DropdownMenuItem(
                            value: roots[i].id,
                            child: Text(
                              roots[i].name,
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                            ),
                          );
                        }),
                        onChanged: !_isRightParent
                            ? (value) {
                                if (value == null) return;
                                setState(() {
                                  rootId = value;
                                  levelChildren.clear();
                                  levelSelected.clear();
                                  selectedSubParent = null;
                                });
                                var auth =
                                    context.read<AuthBloc>().state
                                        as AuthenticatedState;

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

                    //  Add more dropdown levels dynamically based on children
                    if (levelChildren.isNotEmpty) ...?_buildChildrenDropDown(),
                    // Loop through department levels and create dropdowns

                    // Confirmation checkbox (show only when department is selected)
                    if (rootId != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CheckboxListTile(
                          title: Text(
                            context.translate(key: 'confirm_parent_department'),
                          ),
                          subtitle: Text(
                            context.translate(
                              key: 'confirm_parent_department_desc',
                            ),
                          ),
                          value: _isRightParent,
                          onChanged: (value) {
                            setState(() {
                              _isRightParent = value ?? false;
                              //  Stop loading more children when confirmed
                              levelChildren.removeWhere((level, d) {
                                return levelSelected[level] == null ||
                                    levelSelected[level]!.isEmpty;
                              });
                            });
                          },
                        ),
                      ),
                  ],

                  _submitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _departmentListener(BuildContext context, DepartmentState state) {
    if (state.event is DepartmentSuccessEventSealed) {
      var t = context.translate;
      var success = state.event as DepartmentSuccessEventSealed;
      if (success is DepartmentSuccessEvent) {
        setState(() {
          if (state.children.isNotEmpty) {
            int level = state.children[0].level;
            levelChildren[level] = state.children;
          }
        });
        return;
      }

      String title = t(key: success.title);
      String description = t(key: success.message);
      context.successToast(title: title, description: description);

      if (success is DepartmentAddedEvent) context.pop();
      return;
    }

    if (state.event is DepartmentFailedEvent) {
      var t = context.translate;
      var failed = state.event as DepartmentFailedEvent;

      String title = t(key: failed.title);
      String description = t(
        key: failed.message,
      ).replaceAll('\$reason', t(key: failed.reason));

      context.errorToast(title: title, description: description);
      return;
    }

    if (state.event is DeleteDepartmentSuccess) {
      context.successToast(
        title: context.translate(
          key: 'delete_department_success_notification_title',
        ),
        description: context.translate(
          key: 'delete_department_success_notification_desc',
        ),
      );
      return;
    }
  }

  List<Widget>? _buildChildrenDropDown() {
    return levelChildren.entries.map((e) {
      final level = e.key;
      final departments = e.value;
      if (departments.isEmpty) return SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<String>(
          isExpanded: true,
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
                    levelSelected[level] = v;
                    selectedSubParent = v;
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

  Padding _submitButton(BuildContext context) {
    var w = context.watch<DepartmentBloc>();
    bool confirmed = _isRightParent || _isRoot;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: w.state.event is DepartmentLoadingEvent
              ? null
              : !confirmed
              ? null
              : _submitForm,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            context.translate(key: 'add_department_btn'),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    //  Add form validation
    if (_formKey.currentState?.validate() == true) {
      //  Get form data
      String nameAR = _nameARController.text.trim();
      String nameEN = _nameENController.text.trim();
      String levelName = _levelNameController.text.trim();
      parentId = _isRoot ? null : (selectedSubParent ?? rootId);
      Logger.d(
        'name_ar: $nameAR, name_en: $nameEN, level_name: $levelName, parent_id: $parentId',
        tag: 'Add Department',
      );

      //  Create department entity
      var department = CreateDepartmentModel(
        nameAR: nameAR,
        nameEN: nameEN,
        levelName: levelName,
        parentId: parentId,
      );

      department.logInfo(tag: 'Submit');
      var auth = context.read<AuthBloc>().state as AuthenticatedState;

      //  Submit to DepartmentBloc
      context.read<DepartmentBloc>().add(
        DepartmentAddNewRequest(token: auth.token, model: department),
      );
    }
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    required void Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        //  Add validation mode
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon,
        ),
        //  Add validator
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  @override
  void dispose() {
    _nameARController.dispose();
    _nameENController.dispose();
    _levelNameController.dispose();
    super.dispose();
  }
}
