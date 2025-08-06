library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/config/widget/widget_module.dart';
import 'package:moh_eam/features/admin/ui/widgets/admin_widgets_module.dart';
import 'package:moh_eam/features/entity/feature/departments/bloc/bloc.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/entity/department.dart';

class DepartmentView extends StatefulWidget {
  const DepartmentView({super.key});

  @override
  State<DepartmentView> createState() => _DepartmentViewState();
}

class _DepartmentViewState extends State<DepartmentView> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: _appBar(context.isMobile),
      body: _layout(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddDepartment,
        icon: Icon(Icons.add),
        label: Text(context.translate(key: 'add_new_department')),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16),
      child: SearchField(
        hintKey: 'search_departments',
        callback: _onSearchQueryChanged,
      ),
    );
  }

  Widget _buildDepartmentCard(DepartmentEntity department) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => _onDepartmentTap(department),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          department.name,
                          style: context.h6?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          department.levelName,
                          style: context.bodyMedium?.copyWith(
                            color: context.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildActionButtons(department),
                ],
              ),
              SizedBox(height: 12),
              Text(
                '${context.translate(key: 'level')}: ${department.level} • ID: ${department.id}',
                style: context.bodySmall?.copyWith(
                  color: context.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(DepartmentEntity department) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => _onEditDepartment(department),
          icon: Icon(Icons.edit),
          tooltip: context.translate(key: 'edit_action'),
          style: IconButton.styleFrom(
            backgroundColor: context.primaryContainer,
            foregroundColor: context.onPrimaryContainer,
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          onPressed: () => _onDeleteDepartment(department),
          icon: Icon(Icons.delete),
          tooltip: context.translate(key: 'delete_action'),
          style: IconButton.styleFrom(
            backgroundColor: context.errorContainer,
            foregroundColor: context.onErrorContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentsList() {
    var state = context.watch<DepartmentBloc>().state;

    if (state.event is DepartmentFailedEvent) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: context.error),
            SizedBox(height: 16),
            Text(context.translate(key: 'failed_to_load'), style: context.h6),
          ],
        ),
      );
    }

    if (state.event is DepartmentLoadingEvent) {
      return _shimmer();
    }

    if (state.event is DepartmentSuccessEvent) {
      // Filter only root departments (level 0 or no parent)
      final rootDepartments = state.departments
          .where((dept) => dept.parentId == null || dept.level == 0)
          .toList();

      if (rootDepartments.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder_open,
                size: 64,
                color: context.onSurfaceVariant,
              ),
              SizedBox(height: 16),
              Text(
                context.translate(key: 'no_departments_found'),
                style: context.h6,
              ),
              SizedBox(height: 8),
              Text(
                context.translate(key: 'add_first_department'),
                style: context.bodyMedium?.copyWith(
                  color: context.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: rootDepartments.length,
        itemBuilder: (context, index) {
          return _buildDepartmentCard(rootDepartments[index]);
        },
      );
    }

    return SizedBox.shrink();
  }

  Widget _shimmer() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 20,
                        decoration: BoxDecoration(
                          color: context.onSurface.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: 150,
                        height: 16,
                        decoration: BoxDecoration(
                          color: context.onSurface.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 14,
                        decoration: BoxDecoration(
                          color: context.onSurface.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.onSurface.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.onSurface.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _content() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            context.translate(key: 'department_view_title'),
            style: context.h5,
          ),
        ),
        _buildSearchBar(),
        Expanded(child: _buildDepartmentsList()),
      ],
    );
  }

  Widget _layout() {
    if (context.isDesktop || context.isLarge) {
      return Row(
        children: [
          SideBar(),
          Expanded(child: _content()),
        ],
      );
    }
    return _content();
  }

  AppBar _appBar(bool isMobile) {
    return AppBar(
      title: Text(context.translate(key: 'departments')),
      actionsPadding: EdgeInsets.symmetric(
        horizontal: context.responsive.padding,
        vertical: 10,
      ),
      actions: [
        if (!isMobile) ...[LanguageDropdown(), ThemeSwitcher()],
        Image.asset(
          AssetsHelper.mohLogoTextFree,
          scale: context.responsive.scale(15, .8),
        ),
      ],
    );
  }

  void _onDepartmentTap(DepartmentEntity department) {
    // Navigate to DepartmentDetailsView
    // context.pushNamed(
    //   'department_details', // Replace with your actual route name
    //   pathParameters: {"departmentId": department.id},
    // );
  }

  void _onEditDepartment(DepartmentEntity department) {
    // Handle edit department
    Logger.d('Edit department: ${department.id}', tag: 'DepartmentView');
    // You can navigate to edit page or show edit dialog
    // context.pushNamed('edit_department', pathParameters: {"departmentId": department.id});
  }

  void _onDeleteDepartment(DepartmentEntity department) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(context.translate(key: 'delete_confirmation_title')),
          content: Text(context.translate(key: 'delete_confirmation_message')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.translate(key: 'cancel_action')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performDelete(department);
              },
              style: TextButton.styleFrom(foregroundColor: context.error),
              child: Text(context.translate(key: 'delete_action')),
            ),
          ],
        );
      },
    );
  }

  void _performDelete(DepartmentEntity department) {
    // Handle actual deletion
    Logger.d('Delete department: ${department.id}', tag: 'DepartmentView');
    // Add your deletion logic here
    // context.read<DepartmentBloc>().add(DeleteDepartmentEvent(department.id));
  }

  void _onAddDepartment() {
    // Navigate to add department page
    Logger.d('Add new department', tag: 'DepartmentView');
    // context.pushNamed('add_department');
  }

  void _onSearchQueryChanged(String? query) {
    // Handle search query change
    Logger.d('Search query: $query', tag: 'DepartmentView');
    // You can filter the departments or trigger a search in your bloc
    // context.read<DepartmentBloc>().add(SearchDepartmentsEvent(query));
  }
}
