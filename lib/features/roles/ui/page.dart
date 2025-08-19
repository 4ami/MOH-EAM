import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/config/widget/widget_module.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';
import 'package:moh_eam/features/roles/bloc/bloc.dart';
import 'package:moh_eam/features/roles/ui/view/create_role.dart';
import 'package:moh_eam/features/roles/ui/widgets/widgets_module.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: _appBar(context.isMobile),
      body: BlocListener<RoleBloc, RoleState>(
        listener: _listener,
        child: _content(context),
      ),
      floatingActionButton: _addRole(context),
    );
  }

  FloatingActionButton _addRole(BuildContext context) {
    var w = context.watch<RoleBloc>().state;
    return FloatingActionButton.extended(
      onPressed: w.event is PendingRoleEvent ? null : _addRoleCallback,
      label: Text(context.translate(key: 'add_role_btn_label')),
      icon: Icon(Icons.add),
    );
  }

  ListView _rolesBuilder(RoleState w) {
    return ListView.builder(
      itemBuilder: (context, i) {
        return UnconstrainedBox(child: RolesCard(role: w.roles[i]));
      },
      itemCount: w.roles.length,
    );
  }

  Widget _content(BuildContext context) {
    var w = context.watch<RoleBloc>().state;
    if (w.roles.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 25,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            color: Colors.grey.shade300,
            size: context.responsive.scale(100, .6),
          ),
          Text(
            context.translate(key: 'no_roles_found_try_to_add_new'),
            style: context.h2,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
    return _rolesBuilder(w);
  }

  void _addRoleCallback() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
      builder: (_) => BlocProvider<RoleBloc>.value(
        value: context.read<RoleBloc>(),
        child: CreateRoleWidget(),
      ),
    );
  }

  void _listener(BuildContext context, RoleState state) {
    var t = context.translate;
    if (state.event is RoleSuccessEvent) {
      if (state.event is FetchRolesSuccessEvent) return;
      var success = state.event as RoleSuccessEvent;
      String title = t(key: success.title);
      String message = t(key: success.message);
      context.successToast(title: title, description: message);
      if (success is RoleDeleteSuccessEvent ||
          success is RoleCreateSuccessEvent) {
        context.pop();
        var a = context.read<AuthBloc>().state as AuthenticatedState;
        context.read<RoleBloc>().add(FetchRolesEvent(token: a.token));
      }
      return;
    }
    if (state.event is RoleFailedEvent) {
      var failed = state.event as RoleFailedEvent;
      String title = t(key: failed.title);
      String message = t(key: failed.message);
      String reason = t(key: failed.reason);

      context.errorToast(
        title: title,
        description: message.replaceAll('\$reason', reason),
      );
      if (failed is RoleDeleteFailedEvent) context.pop();
      return;
    }
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
}
