library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/routing/_helpers/_routing_helpers_module.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/config/widget/widget_module.dart';
import 'package:moh_eam/core/domain/entity/entity_model.dart';
import 'package:moh_eam/features/entity/feature/departments/domain/entity/department.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/entity/device.dart';
import 'package:moh_eam/features/admin/ui/widgets/admin_widgets_module.dart';
import 'package:moh_eam/features/auth/domain/entities/user_entity.dart';
import 'package:moh_eam/features/entity/ui/widgets/entity_widgets_module.dart';

export 'widgets/entity_widgets_module.dart';

class EntityViewerPage<T extends EntityModel> extends StatefulWidget {
  final T entity;
  const EntityViewerPage({super.key, required this.entity});

  @override
  State<EntityViewerPage<T>> createState() => _EntityViewerPageState<T>();
}

class _EntityViewerPageState<T extends EntityModel>
    extends State<EntityViewerPage<T>> {
  late Map<String, dynamic> map = widget.entity.toTableRow();
  late List<String> props = widget.entity.props;

  @override
  Widget build(BuildContext context) {
    final hasEdit = AuthorizationHelper.hasMinimumPermission(
      context,
      widget.entity.resourceName,
      'UPDATE',
    );
    final hasDelete = AuthorizationHelper.hasMinimumPermission(
      context,
      widget.entity.resourceName,
      'DELETE',
    );

    return ResponsiveScaffold(
      appBar: _appBar(context.isMobile),
      drawer: Drawer(child: AdminDrawerBody()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 17,
                children: [
                  Header(resourceName: widget.entity.resourceName),
                  ...props.map(
                    (prop) => DetailItem(
                      label: context.translate(key: prop),
                      value: map[prop],
                    ),
                  ),
                  EntityActions(
                    hasEdit: hasEdit,
                    hasDelete: hasDelete,
                    onDelete: _onDelete,
                    onEdit: _onEdit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar(bool isMobile) {
    return AppBar(
      title: Text(
        context.translate(key: '${widget.entity.resourceName}_details'),
      ),
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

  void _onEdit() {
    if (widget.entity is DepartmentEntity) {
      context.pushNamed(
        AppRoutesInformation.editDepartment.name,
        extra: widget.entity as DepartmentEntity,
        pathParameters: GoRouter.of(context).state.pathParameters,
      );
      return;
    } else if (widget.entity is DeviceEntity) {
      context.pushNamed(
        AppRoutesInformation.editDevice.name,
        extra: widget.entity as DeviceEntity,
        pathParameters: GoRouter.of(context).state.pathParameters,
      );
      return;
    } else if (widget.entity is UserEntity) {
      context.pushNamed(
        AppRoutesInformation.editUser.name,
        extra: widget.entity as UserEntity,
        pathParameters: GoRouter.of(context).state.pathParameters,
      );
      return;
    }

    context.go('/error');
  }

  void _onDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.translate(key: 'delete_confirmation_title')),
        content: Text(context.translate(key: 'delete_confirmation_message')),
        actions: [
          TextButton(
            onPressed: () => context.pop(ctx),
            child: Text(context.translate(key: 'cancel_action')),
          ),
          TextButton(
            onPressed: () {
              //Delete then pop
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
}
