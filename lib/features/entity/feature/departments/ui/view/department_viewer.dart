import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/config/widget/widget_module.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';
import 'package:moh_eam/features/entity/feature/departments/bloc/bloc.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/entity/department.dart';
import 'package:moh_eam/features/entity/feature/departments/ui/view/update_department.dart';

class DepartmentViewer extends StatefulWidget {
  const DepartmentViewer({super.key});

  @override
  State<DepartmentViewer> createState() => _DepartmentViewerState();
}

class _DepartmentViewerState extends State<DepartmentViewer> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: _appBar(context.isMobile),
      body: BlocListener<DepartmentBloc, DepartmentState>(
        listener: (context, state) {
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

          if (state.event is DepartmentDeleteFailedEvent) {
            String desc = context.translate(
              key: 'delete_department_failed_notification_desc',
            );
            String reason = context.translate(key: state.event.message);
            desc = desc.replaceAll('\$reason', reason);

            context.errorToast(
              title: context.translate(
                key: 'delete_department_failed_notification_title',
              ),
              description: desc,
            );
            return;
          }

          if (state.event is UpdateDepartmentSuccess) {
            context.successToast(
              title: context.translate(
                key: 'update_department_success_notification_title',
              ),
              description: context.translate(
                key: 'update_department_success_notification_desc',
              ),
            );
            return;
          }

          if (state.event is DepartmentUpdateFailedEvent) {
            String desc = context.translate(
              key: 'update_department_failed_notification_desc',
            );
            String reason = context.translate(key: state.event.message);
            desc = desc.replaceAll('\$reason', reason);
            context.errorToast(
              title: context.translate(
                key: 'update_department_failed_notification_title',
              ),
              description: desc,
            );
            return;
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
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
      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.only(bottom: 16, left: index * 20.0),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: context.surfaceTint,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(width: double.infinity, height: 20),
                        SizedBox(height: 4),
                        _shimmerBox(width: 150, height: 16),
                        SizedBox(height: 4),
                        _shimmerBox(width: 100, height: 14),
                      ],
                    ),
                  ),
                  _shimmerBox(width: 40, height: 40, radius: 20),
                  SizedBox(width: 8),
                  _shimmerBox(width: 40, height: 40, radius: 20),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (state.event is DepartmentSuccessEvent ||
        state.event is UpdateDepartmentSuccess ||
        state.event is DeleteDepartmentSuccess) {
      final sortedDepartments = state.departments
        ..sort((a, b) => a.level.compareTo(b.level));
      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: sortedDepartments.length,
        itemBuilder: (context, index) => _buildCard(sortedDepartments[index]),
      );
    }

    return SizedBox.shrink();
  }

  Widget _buildCard(DepartmentEntity department) {
    bool enabled =
        context.watch<DepartmentBloc>().state.event is! DepartmentLoadingEvent;
    return Container(
      margin: EdgeInsets.only(bottom: 16, left: department.level * 20.0),
      child: Card(
        color: department.level == 0 ? context.primaryContainer : null,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              if (department.level == 0)
                Icon(Icons.account_tree, color: context.primary),
              if (department.level > 0)
                Icon(
                  Icons.subdirectory_arrow_right,
                  size: 16,
                  color: context.onSurfaceVariant,
                ),
              if (department.level > 0 || department.level == 0)
                SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      department.name,
                      style: department.level == 0 ? context.h5 : context.h6,
                    ),
                    SizedBox(height: 4),
                    Text(
                      department.levelName,
                      style: context.bodyMedium?.copyWith(
                        color: context.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Level: ${department.level} • ID: ${department.id}',
                      style: context.bodySmall?.copyWith(
                        color: context.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (AuthorizationHelper.hasMinimumPermission(
                context,
                'departments',
                'UPDATE',
              ))
                IconButton(
                  onPressed: enabled ? () => _edit(department) : null,
                  icon: Icon(Icons.edit),
                  style: IconButton.styleFrom(
                    backgroundColor: context.primaryContainer,
                  ),
                ),
              SizedBox(width: 8),
              if (AuthorizationHelper.hasMinimumPermission(
                context,
                'departments',
                'DELETE',
              ))
                IconButton(
                  onPressed: enabled ? () => _delete(department) : null,
                  icon: Icon(Icons.delete),
                  style: IconButton.styleFrom(
                    backgroundColor: context.errorContainer,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _edit(DepartmentEntity department) {
    Logger.d('Edit department: ${department.id}', tag: 'DepartmentView');
    // You can navigate to edit page or show edit dialog
    // context.pushNamed('edit_department', pathParameters: {"departmentId": department.id});

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BlocProvider<DepartmentBloc>(
          create: (context) => DepartmentBloc(),
          child: UpdateDepartmentWidget(department: department),
        );
      },
    );
  }

  void _delete(DepartmentEntity department) {
    String key = department.level == 0
        ? 'delete_root_confirmation_message'
        : 'delete_root_confirmation_message';
    showDialog(
      context: context,
      builder: (_) => BlocProvider<DepartmentBloc>(
        create: (context) => DepartmentBloc(),
        child: AlertDialog(
          title: Text(context.translate(key: 'delete_confirmation_title')),
          content: Text(context.translate(key: key)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.translate(key: 'cancel_action')),
            ),
            TextButton(
              onPressed: () {
                Logger.d(
                  'Delete department: ${department.id}',
                  tag: 'DepartmentView',
                );
                // Add your deletion logic here
                var auth = context.read<AuthBloc>().state as AuthenticatedState;
                context.read<DepartmentBloc>().add(
                  DeleteDepartmentEvent(
                    token: auth.token,
                    departmentId: department.id,
                  ),
                );
                context.pop();
              },
              child: Text(
                context.translate(key: 'delete_action'),
                style: TextStyle(color: context.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    double? radius,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: Duration(milliseconds: 1000),
      builder: (context, value, child) {
        return AnimatedBuilder(
          animation: AlwaysStoppedAnimation(value),
          builder: (context, child) {
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: context.surfaceTint.withValues(alpha: value),
                borderRadius: BorderRadius.circular(radius ?? 4),
              ),
            );
          },
        );
      },
    );
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
}
