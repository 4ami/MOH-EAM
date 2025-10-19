import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/config/widget/pagination_filter.dart';
import 'package:moh_eam/config/widget/widget_module.dart';
import 'package:moh_eam/features/admin/ui/widgets/admin_widgets_module.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';
import 'package:moh_eam/features/entity/feature/devices/ui/widgets/device_widgets_module.dart';
import 'package:moh_eam/features/logs/bloc/bloc.dart';
import 'package:moh_eam/features/logs/ui/widgets/logs_widgets_module.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
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

  void _listener(BuildContext context, LogsState state) {
    if (state.event is LogsSuccessEvent) {
      var t = context.translate;
      var success = state.event as LogsSuccessEvent;

      var title = t(key: success.title);
      var message = t(key: success.message);
      context.successToast(title: title, description: message);
      return;
    }

    if (state.event is LogsFailEvent) {
      var t = context.translate;
      var failed = state.event as LogsFailEvent;
      var title = t(key: failed.title);
      var message = t(
        key: failed.message,
      ).replaceAll('\$reason', t(key: failed.reason));

      context.errorToast(title: title, description: message);
      return;
    }
  }

  String? query;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogsBloc, LogsState>(
      listener: _listener,
      child: ResponsiveScaffold(
        appBar: _appBar(context.isMobile),
        body: _layout(),
      ),
    );
  }

  Widget _layout() {
    if (context.isDesktop || context.isLarge) {
      return Row(
        children: [
          SideBar(),
          Expanded(child: SingleChildScrollView(child: _content())),
        ],
      );
    }
    return _content();
  }

  Widget _content() {
    var s = context.watch<LogsBloc>().state;
    var h = s.history;

    if (context.isDesktop || context.isLarge) {
      return Column(
        spacing: 15,
        children: [
          // Filters,
          _buildUtil(),
          _buildTable(),
          if (s.event is! LogsPendingEvent)
            if (s.event is FetchLogsSuccessEvent)
              PaginationFilter(
                maxPages: s.max,
                currentPage: s.page,
                onPageSelect: (p) {
                  Logger.d('Page changed -> $p', tag: 'Device PF');
                  var bloc = context.read<LogsBloc>();
                  bloc.add(SetPage(page: p));
                  // trigger search
                  var a = context.read<AuthBloc>().state as AuthenticatedState;
                  bloc.add(
                    FetchLogsEvent(
                      token: a.token,
                      query: bloc.state.query,
                      state: bloc.state.state,
                    ),
                  );
                },
              )
            else
              SizedBox.shrink()
          else
            PaginationFilter.render(),
        ],
      );
    }

    return CustomScrollView(
      slivers: [
        //Filters,
        SliverToBoxAdapter(child: _buildUtil()),
        SliverList.builder(
          itemCount: h.length,
          itemBuilder: (context, i) {
            return LogsCard(log: h[i]);
          },
        ),

        if (s.event is LogsPendingEvent)
          SliverToBoxAdapter(child: PaginationFilter.render()),

        if (s.event is LogsSuccessEvent)
          SliverToBoxAdapter(
            child: PaginationFilter(
              maxPages: s.max,
              currentPage: s.page,
              onPageSelect: (p) {
                Logger.d('Page changed -> $p', tag: 'Device PF');
                var bloc = context.read<LogsBloc>();
                bloc.add(SetPage(page: p));
                // trigger search
                var a = context.read<AuthBloc>().state as AuthenticatedState;
                bloc.add(
                  FetchLogsEvent(
                    token: a.token,
                    query: bloc.state.query,
                    state: bloc.state.state,
                  ),
                );
              },
            ),
          )
        else
          SliverToBoxAdapter(child: SizedBox.shrink()),
      ],
    );
  }

  Widget _buildTable() {
    var s = context.watch<LogsBloc>().state;
    if (s.event is LogsFailEvent) {
      return Text('Failed');
    }

    if (s.event is LogsPendingEvent) {
      return LogsTable.render();
    }

    return LogsTable(logs: s.history);
  }

  Widget _buildUtil({bool vertical = false}) {
    if (vertical) {
      return Column(
        spacing: 10,
        children: [
          SearchField(hintKey: '', callback: _onQueryChanged),
          MovementStateDropDown(onChanged: _onStateChanged),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onSearch,
              child: Text(context.translate(key: 'search')),
            ),
          ),

          TextButton.icon(
            onPressed: _reset,
            label: Text(context.translate(key: 'reset_filters')),
            icon: Icon(Icons.restore_outlined),
          ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Switch to vertical layout on small screens
        if (constraints.maxWidth < 600) {
          return _buildUtil(vertical: true);
        }

        return SizedBox(
          width: math.min(
            constraints.maxWidth * 0.95,
            context.responsive.width(.75),
          ),
          child: Row(
            children: [
              // Flexible search field that takes available space
              Expanded(
                flex: 2,
                child: SearchField(hintKey: '', callback: _onQueryChanged),
              ),
              SizedBox(width: 10),
              // Filter widget with flexible sizing
              Flexible(
                flex: 1,
                child: MovementStateDropDown(onChanged: _onStateChanged),
              ),
              SizedBox(width: 10),
              // Search button with constrained width
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: 80, maxWidth: 120),
                child: ElevatedButton(
                  onPressed: _onSearch,
                  child: Text(
                    context.translate(key: 'search'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              Flexible(
                child: TextButton.icon(
                  onPressed: _reset,
                  label: Text(context.translate(key: 'reset_filters')),
                  icon: Icon(Icons.restore_outlined),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _reset() {
    var l = context.read<LogsBloc>();
    l.add(SetLogsState(state: null));
    setState(() {
      query = null;
    });
  }

  void _onStateChanged(String state) {
    var l = context.read<LogsBloc>();
    l.add(SetLogsState(state: state));
  }

  void _onQueryChanged(String? q) {
    setState(() {
      query = q;
    });
  }

  void _onSearch() {
    var l = context.read<LogsBloc>();
    var a = context.read<AuthBloc>().state as AuthenticatedState;
    var state = l.state.state;
    l.add(FetchLogsEvent(token: a.token, query: query, state: state));
  }
}
