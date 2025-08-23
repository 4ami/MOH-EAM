import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/core/bloc/global_bloc_module.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';
import 'package:moh_eam/features/entity/feature/departments/bloc/bloc.dart';
import 'package:moh_eam/features/entity/feature/departments/data/model/update_department.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/entity/department.dart';

class UpdateDepartmentWidget extends StatefulWidget {
  final DepartmentEntity department;

  const UpdateDepartmentWidget({super.key, required this.department});

  @override
  State<UpdateDepartmentWidget> createState() => _UpdateDepartmentWidgetState();
}

class _UpdateDepartmentWidgetState extends State<UpdateDepartmentWidget> {
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
  bool _isInitialized = false;
  bool _isLoading = false;
  List<DepartmentEntity> _departmentTree = [];

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    // Initialize form fields with existing department data
    _nameARController.text = '';
    _nameENController.text = '';
    _levelNameController.text = widget.department.levelName;

    // Set parent information
    parentId = widget.department.parentId;
    _isRoot = widget.department.level == 0;

    _loadDepartmentHierarchy();

    _isInitialized = true;
  }

  void _loadDepartmentHierarchy() {
    // Load the parent hierarchy to show current selection
    if (!_isRoot) {
      setState(() {
        _isLoading = true;
      });

      var auth = context.read<AuthBloc>().state as AuthenticatedState;
      var lang = context.read<LanguageCubit>().state.languageCode;

      context.read<DepartmentBloc>().add(
        DepartmentRequestTree(
          token: auth.token,
          id: widget.department.id,
          lang: lang,
        ),
      );
    }
  }

  void _buildHierarchyFromTree() {
    if (_departmentTree.isEmpty) return;

    // Find current department's parent chain
    DepartmentEntity currentDept = _departmentTree.firstWhere(
      (dept) => dept.id == widget.department.id,
      orElse: () => widget.department,
    );

    // Build parent chain from root to current department's parent
    List<String> parentChain = [];
    String? parentId = currentDept.parentId;

    while (parentId != null) {
      parentChain.insert(0, parentId);
      var match = _departmentTree.where((dept) => dept.id == parentId);
      DepartmentEntity? parent = match.isNotEmpty ? match.first : null;
      parentId = parent?.parentId;
    }

    // Set selections based on parent chain
    Map<int, String?> selections = {};
    for (int i = 0; i < parentChain.length; i++) {
      DepartmentEntity parent = _departmentTree.firstWhere(
        (d) => d.id == parentChain[i],
      );
      selections[parent.level] = parent.id;
    }

    // Set root if exists
    if (parentChain.isNotEmpty) {
      DepartmentEntity rootParent = _departmentTree.firstWhere(
        (d) => d.id == parentChain[0],
      );
      if (rootParent.level == 0) {
        rootId = rootParent.id;
      }
      selectedSubParent = parentChain.last;
    }

    setState(() {
      levelSelected = selections;
      _isRightParent = true;
    });
  }

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
                children: [
                  // Department ID display (read-only)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      initialValue: widget.department.id,
                      decoration: InputDecoration(
                        labelText: context.translate(key: 'id'),
                        border: const OutlineInputBorder(),
                      ),
                      readOnly: true,
                      style: TextStyle(
                        color: context.onSurface.withValues(alpha: .6),
                      ),
                    ),
                  ),

                  _buildField(
                    controller: _nameARController,
                    label: context.translate(key: 'name_ar'),
                    validator: (ar) =>
                        ValidationHelper.fullName(ar, context, isAr: true),
                    onChanged: (n) {
                      // Handle name AR changes if needed
                    },
                  ),

                  _buildField(
                    controller: _nameENController,
                    label: context.translate(key: 'name_en'),
                    validator: (en) =>
                        ValidationHelper.fullName(en, context, isAr: false),
                    onChanged: (n) {
                      // Handle name EN changes if needed
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
                            // Load root departments for selection
                          } else {
                            // Clear department selection
                            selectedSubParent = null;
                            levelChildren.clear();
                            levelSelected.clear();
                            parentId = null;
                          }
                          _isRightParent = _isRoot; // Auto-confirm if root
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
                      // Handle level name changes if needed
                    },
                  ),

                  if (!_isRoot) ...[
                    if (_isLoading) ...[
                      _buildShimmerDropdown(
                        context.translate(key: 'root_departments'),
                      ),
                      _buildShimmerDropdown(
                        context
                            .translate(key: 'sub_departments_level')
                            .replaceAll('\$level', '1'),
                      ),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          validator: (v) =>
                              ValidationHelper.dropDown(v, context),
                          value: rootId,
                          decoration: InputDecoration(
                            labelText: context.translate(
                              key: 'root_departments',
                            ),
                            border: OutlineInputBorder(),
                          ),
                          items: List.generate(roots.length, (i) {
                            return DropdownMenuItem(
                              value: roots[i].id,
                              child: Text(roots[i].name),
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
                                    _isRightParent = false;
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
                    ],

                    // Add more dropdown levels dynamically based on children
                    if (levelChildren.isNotEmpty) ...?_buildChildrenDropDown(),

                    // Confirmation checkbox (show only when department is selected)
                    if (rootId != null ||
                        _isInitialized && widget.department.parentId != null)
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
                              // Stop loading more children when confirmed
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
            levelChildren[level] = state.children
                .where((e) => e.id != widget.department.id)
                .toList();
          }
        });
        return;
      }

      if (success is DepartmentTreeSuccess) {
        setState(() {
          _isLoading = false;
          _departmentTree = (state.event as DepartmentTreeSuccess).departments
              .where((e) => e.id != widget.department.id)
              .toList();
          _buildHierarchyFromTree();
        });
        return;
      }

      String title = t(key: success.title);
      String description = t(key: success.message);
      context.successToast(title: title, description: description);

      if (success is UpdateDepartmentSuccess) context.pop();
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

  Widget _buildShimmerDropdown(String label) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      height: 16,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed:
              context.watch<DepartmentBloc>().state.event
                  is DepartmentLoadingEvent
              ? null
              : (_isRoot || _isRightParent)
              ? _submitForm
              : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            context.translate(key: 'update_department_btn'),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    // Add form validation
    if (_formKey.currentState?.validate() == true) {
      // Get form data
      String nameAR = _nameARController.text.trim();
      String nameEN = _nameENController.text.trim();
      String levelName = _levelNameController.text.trim();
      String? finalParentId = _isRoot ? null : (selectedSubParent ?? rootId);

      Logger.d(
        'Updating Department - ID: ${widget.department.id}, name_ar: $nameAR, name_en: $nameEN, level_name: $levelName, parent_id: $finalParentId',
        tag: 'Update Department',
      );

      // Create update department model
      var updateModel = UpdateDepartmentRequest(
        id: widget.department.id,
        nameAR: nameAR,
        nameEN: nameEN,
        levelName: levelName,
        parentId: finalParentId,
        rootLevel: _isRoot,
      );

      updateModel.logInfo(tag: 'Submit Update');
      var auth = context.read<AuthBloc>().state as AuthenticatedState;

      // Submit to DepartmentBloc
      context.read<DepartmentBloc>().add(
        UpdateDepartmentEvent(token: auth.token, request: updateModel),
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
        // Add validation mode
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon,
        ),
        // Add validator
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
