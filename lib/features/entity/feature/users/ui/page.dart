library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/config/routing/routing_module.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/config/widget/pagination_filter.dart';
import 'package:moh_eam/config/widget/widget_module.dart';
import 'package:moh_eam/features/entity/feature/users/bloc/bloc.dart';
import 'package:moh_eam/features/admin/ui/widgets/admin_widgets_module.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';
import 'package:moh_eam/features/entity/feature/users/domain/entity/user_entity.dart';
import 'package:moh_eam/features/entity/feature/users/ui/view/create_user.dart';

export 'widgets/users_widgets_module.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  @override
  Widget build(BuildContext context) {
    bool canCreate = AuthorizationHelper.hasMinimumPermission(
      context,
      'users',
      'CREATE',
    );
    return BlocListener<UserEntityBloc, UserEntityState>(
      listener: _listener,
      child: ResponsiveScaffold(
        appBar: _appBar(context.isMobile),
        drawer: Drawer(child: AdminDrawerBody()),
        body: _layout(),
        floatingActionButton: canCreate ? _addUser(context) : null,
      ),
    );
  }

  FloatingActionButton _addUser(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => CreateUserWidget(),
        );
      },
      label: Text(context.translate(key: 'create_user_btn_label')),
      icon: Icon(Icons.add),
    );
  }

  void _listener(BuildContext context, UserEntityState state) {}

  Widget _content() {
    var state = context.watch<UserEntityBloc>().state;
    var users = state.users;
    if (context.isDesktop || context.isLarge) {
      return Column(
        spacing: 15,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: _buildUtil(),
          ),
          _buildTable(),
          if (state.event is! UserEntityLoadingEvent)
            if (state.event is UserEntitySuccessEvent)
              PaginationFilter(
                maxPages: state.maxPage,
                currentPage: state.filters.page,
                onPageSelect: (p) {
                  Logger.d('Page changed -> $p', tag: 'User PF');
                  context.read<UserEntityBloc>().add(
                    UserEntitySearchFiltersChanged(page: UpdateTo(p)),
                  );
                  // trigger search
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
        SliverToBoxAdapter(child: _buildUtil(vertical: true)),
        SliverList.builder(
          itemCount: users.length,
          itemBuilder: (context, i) {
            return EntityCard(
              entity: users[i],
              onView: (entity) {
                Logger.d(entity.id);
                context.pushNamed(
                  AppRoutesInformation.viewUser.name,
                  pathParameters: {"user": entity.id},
                );
              },
            );
          },
        ),

        if (state.event is UserEntityLoadingEvent)
          SliverToBoxAdapter(child: PaginationFilter.render()),
        if (state.event is UserEntitySuccessEvent)
          SliverToBoxAdapter(
            child: PaginationFilter(
              maxPages: state.maxPage,
              currentPage: state.filters.page,
              onPageSelect: (p) {
                Logger.d('Page changed -> $p', tag: 'User PF');
                context.read<UserEntityBloc>().add(
                  UserEntitySearchFiltersChanged(page: UpdateTo(p)),
                );
                // trigger search
              },
            ),
          )
        else
          SliverToBoxAdapter(child: SizedBox.shrink()),
      ],
    );
  }

  Widget _buildTable() {
    var state = context.watch<UserEntityBloc>().state;
    if (state.event is UserEntityFailedEvent) {
      return Text('Failed');
    }
    if (state.event is UserEntitySuccessEvent) {
      if (state.users.isEmpty) {
        return Text(context.translate(key: 'empty_result'), style: context.h3);
      }
      return EntityTable<UserEntity>(
        entities: state.users,
        tableCols: UserEntity.tableCols,
        onView: (entity) {
          context.pushNamed(
            AppRoutesInformation.viewUser.name,
            pathParameters: {"user": entity.id},
          );
        },
      );
    }
    return EntityTable.render();
  }

  Widget _buildUtil({bool vertical = false}) {
    if (vertical) {
      return Column(
        spacing: 10,
        children: [
          SearchField(callback: _onSearchQueryChanged),
          Filter(resource: 'users'),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onSearch,
              child: Text(context.translate(key: 'search')),
            ),
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
                flex: 3,
                child: SearchField(callback: _onSearchQueryChanged),
              ),
              SizedBox(width: 10),
              // Filter widget with flexible sizing
              Flexible(flex: 1, child: Filter(resource: 'users')),
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
            ],
          ),
        );
      },
    );
  }

  void _onSearchQueryChanged(String? p0) {
    context.read<UserEntityBloc>().add(
      UserEntitySearchFiltersChanged(query: UpdateTo(p0)),
    );
  }

  void _onSearch() {
    var auth = context.read<AuthBloc>().state as AuthenticatedState;
    context.read<UserEntityBloc>().add(
      UserEntityFetchUsersEvent(token: auth.token),
    );
    context.read<UserEntityBloc>().state.filters.logDebug(
      tag: 'Search Trigger',
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
