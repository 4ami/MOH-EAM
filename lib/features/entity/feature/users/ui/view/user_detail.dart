import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/routing/_helpers/_routing_helpers_module.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/config/widget/widget_module.dart';
import 'package:moh_eam/features/entity/feature/users/bloc/bloc.dart';
import 'package:moh_eam/features/entity/ui/widgets/entity_widgets_module.dart';
import 'package:moh_eam/features/admin/ui/widgets/admin_widgets_module.dart';

class UserDetailsView extends StatefulWidget {
  const UserDetailsView({super.key});

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  @override
  Widget build(BuildContext context) {
    final hasEdit = AuthorizationHelper.hasMinimumPermission(
      context,
      'users',
      'UPDATE',
    );
    final hasDelete = AuthorizationHelper.hasMinimumPermission(
      context,
      'users',
      'DELETE',
    );

    var w = context.watch<UserEntityBloc>().state;
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
                children: w.event is UserEntityLoadingEvent
                    ? _render()
                    : _content(hasEdit, hasDelete),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _content(bool hasEdit, bool hasDelete) {
    var w = context.watch<UserEntityBloc>().state;
    if (w.event is UserEntitySuccessEvent) {
      return [
        Header(resourceName: w.user!.resourceName),
        ...w.user!.props.map(
          (prop) => DetailItem(
            label: context.translate(key: prop),
            value: w.user!.toTableRow()[prop],
          ),
        ),
        EntityActions(
          hasEdit: hasEdit,
          hasDelete: hasDelete,
          onDelete: _onDelete,
          onEdit: _onEdit,
        ),
      ];
    }

    return [Text('data')];
  }

  List<Widget> _render() {
    return [Header.render(), EntityActions.render()];
  }

  AppBar _appBar(bool isMobile) {
    return AppBar(
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
    var w = context.read<UserEntityBloc>().state;

    if (w.event is UserEntitySuccessEvent && w.user != null) {
      var pathParam = {"resource": 'users', "id": w.user?.id ?? ''};
      context.pushNamed(
        AppRoutesInformation.editUser.name,
        extra: w.user,
        pathParameters: pathParam,
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
