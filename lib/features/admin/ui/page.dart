library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/config/widget/widget_module.dart';
import 'package:moh_eam/core/bloc/global_bloc_module.dart';
import 'package:moh_eam/features/admin/admin_module.dart';
import 'package:moh_eam/features/admin/bloc/bloc.dart';
export 'widgets/admin_widgets_module.dart';
export 'views/admin_views_module.dart';

class AdminMain extends StatefulWidget {
  const AdminMain({super.key});

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _statisticsLoading = false;

  @override
  Widget build(BuildContext context) {
    bool isMobile = context.isMobile;
    return BlocListener<AdminBloc, AdminState>(
      listener: _listener,
      child: ResponsiveScaffold(
        key: _scaffoldKey,
        appBar: _appBar(isMobile),
        drawer: Drawer(child: AdminDrawerBody()),
        body: _layout(),
      ),
    );
  }

  void _listener(BuildContext context, AdminState state) {
    if (state.event is AdminDashboardLoadEvent) {
      setState(() => _statisticsLoading = true);
      return;
    }
    if (state.event is AdminDashboardSuccess) {
      setState(() => _statisticsLoading = false);
      var roles = context.read<AdminBloc>().state.roles;
      var depts = context.read<AdminBloc>().state.departments;
      var gdb = context.read<GlobalDataBloc>();
      gdb.add(SetGlobalRolesDataEvent(roles: roles));
      gdb.add(SetGlobalDepartmentDataEvent(rootDepartments: depts));
      return;
    }

    if (state.event is AdminDashboardFailed) {
      setState(() => _statisticsLoading = false);
      return;
    }
  }

  Widget _layout() {
    if (context.isMobile) return _content();
    return Row(
      children: [
        SideBar(),
        Expanded(child: _content()),
      ],
    );
  }

  SingleChildScrollView _content() {
    return SingleChildScrollView(
      child: Padding(
        padding: context.pagePadding,
        child: Column(
          spacing: 35,
          children: [
            ShaderMask(
              shaderCallback: (b) {
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xff008755), Color(0xff9b945f)],
                ).createShader(b);
              },
              blendMode: BlendMode.srcIn,
              child: Text(
                context.translate(key: 'splash_title'),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.bodyLarge,
              ),
            ),
            AdminSearchBar(),
            QuickAccessCards(),
            _section('dashboard_visuals'),
            if (_statisticsLoading)
              DevicesPerTypeChart.render()
            else
              DevicesPerTypeChart(),
          ],
        ),
      ),
    );
  }

  Widget _section(String key) {
    return Row(
      spacing: 15,
      children: [
        Text(context.translate(key: key), overflow: TextOverflow.ellipsis),
        Expanded(child: Divider()),
      ],
    );
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
