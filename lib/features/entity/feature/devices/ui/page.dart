import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/config/widget/pagination_filter.dart';
import 'package:moh_eam/config/widget/widget_module.dart';
import 'package:moh_eam/features/admin/ui/widgets/admin_widgets_module.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';
import 'package:moh_eam/features/entity/feature/devices/bloc/bloc.dart';
import 'package:moh_eam/features/entity/feature/devices/data/repositories/device_repo_imp.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/entity/device.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/entity/filters.dart';
import 'package:moh_eam/features/entity/feature/devices/domain/services/export_devices.dart';
import 'package:moh_eam/features/entity/feature/devices/ui/view/create_device.dart';
import 'package:moh_eam/features/entity/feature/devices/ui/view/update_device.dart';
import 'package:moh_eam/features/entity/feature/users/bloc/bloc.dart';

class DeviceView extends StatefulWidget {
  const DeviceView({super.key});

  @override
  State<DeviceView> createState() => _DeviceViewState();
}

class _DeviceViewState extends State<DeviceView> {
  @override
  Widget build(BuildContext context) {
    bool canCreate = AuthorizationHelper.hasMinimumPermission(
      context,
      'devices',
      'CREATE',
    );
    return BlocListener<DeviceBloc, DeviceState>(
      listener: _listener,
      child: ResponsiveScaffold(
        appBar: _appBar(context.isMobile),
        body: _layout(),
        floatingActionButton: canCreate ? _createDevice(context) : null,
      ),
    );
  }

  void _listener(BuildContext context, DeviceState state) {
    if (state.event is FailedDeviceEvent) {
      var t = context.translate;
      var failed = state.event as FailedDeviceEvent;
      var title = t(key: failed.title);
      var message = t(
        key: failed.message,
      ).replaceAll('\$reason', t(key: failed.reason));

      context.errorToast(title: title, description: message);
      return;
    }

    if (state.event is SuccessDeviceEvent) {
      var t = context.translate;
      var success = state.event as SuccessDeviceEvent;

      if (success is FetchSuccessEvent) return;

      var title = t(key: success.title);
      var message = t(key: success.message);
      context.successToast(title: title, description: message);
      if (success is CreateSuccessEvent) context.pop();
      if (success is DeleteSuccessEvent) context.pop();
      if (success is PatchSuccessEvent) context.pop();
      var a = context.read<AuthBloc>().state as AuthenticatedState;
      context.read<DeviceBloc>().add(FetchDevicesEvent(token: a.token));
      return;
    }
  }

  FloatingActionButton _createDevice(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<DeviceBloc>()),
                BlocProvider<UserEntityBloc>(
                  create: (_) {
                    return UserEntityBloc();
                  },
                ),
              ],
              child: CreateDeviceWidget(),
            );
          },
        );
      },
      label: Text(context.translate(key: 'add_device_btn')),
      icon: Icon(Icons.add),
    );
  }

  Widget _buildTable() {
    var state = context.watch<DeviceBloc>().state;
    if (state.event is FetchFailedEvent) {
      return Text('Failed');
    }
    if (state.event is FetchSuccessEvent) {
      if (state.devices.isEmpty) {
        return Text(context.translate(key: 'empty_result'), style: context.h3);
      }
      bool edit = AuthorizationHelper.hasMinimumPermission(
        context,
        'devices',
        'UPDATE',
      );
      bool delete = AuthorizationHelper.hasMinimumPermission(
        context,
        'devices',
        'DELETE',
      );
      return EntityTable<DeviceEntity>(
        entities: state.devices,
        tableCols: DeviceEntity.tableCols,
        showMore: false,
        edit: edit,
        delete: delete,
        onUpdate: (entity) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: context.read<DeviceBloc>()),
                  BlocProvider<UserEntityBloc>(
                    create: (_) {
                      return UserEntityBloc();
                    },
                  ),
                ],
                child: UpdateDeviceWidget(device: entity),
              );
            },
          );
        },
        onDelete: (entity) => _onDelete(entity.id),
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
          Filter(resource: 'devices'),
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
              Flexible(flex: 1, child: Filter(resource: 'devices')),
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

  void _onExportSuccess() {
    var t = context.translate;
    context.successToast(
      title: t(key: 'export_success_title'),
      description: t(key: 'export_success_description'),
    );
  }

  void _onExportFailed() {
    var t = context.translate;
    context.errorToast(
      title: t(key: 'export_failed_title'),
      description: 'export_failed_description',
    );
  }

  void _export() async {
    var service = ExportDevicesService(DeviceRepoImp());
    var a = context.read<AuthBloc>().state as AuthenticatedState;
    var token = a.token;
    await service.call(
      token: token,
      onError: _onExportFailed,
      onSuccess: _onExportSuccess,
    );
  }

  Widget _content() {
    var state = context.watch<DeviceBloc>().state;
    var devices = state.devices;
    if (context.isDesktop || context.isLarge) {
      return Column(
        spacing: 15,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ExportButton(labelKey: 'export_devices', onPressed: _export),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: _buildUtil(),
          ),
          _buildTable(),
          if (state.event is! DeviceLoadingEvent)
            if (state.event is FetchSuccessEvent)
              PaginationFilter(
                maxPages: state.max,
                currentPage: state.filters.page,
                onPageSelect: (p) {
                  Logger.d('Page changed -> $p', tag: 'Device PF');
                  var bloc = context.read<DeviceBloc>();
                  bloc.add(
                    UpdateDeviceFilters(
                      filters: bloc.state.filters.copyWith(
                        page: UpdateDeviceFilterTo(p),
                      ),
                    ),
                  );
                  // trigger search
                  var a = context.read<AuthBloc>().state as AuthenticatedState;
                  bloc.add(FetchDevicesEvent(token: a.token));
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
        SliverToBoxAdapter(
          child: ExportButton(labelKey: 'export_devices', onPressed: _export),
        ),
        SliverToBoxAdapter(child: _buildUtil(vertical: true)),
        SliverList.builder(
          itemCount: devices.length,
          itemBuilder: (context, i) {
            return EntityCard(
              entity: devices[i],
              onView: (entity) {
                // context.pushNamed(
                //   AppRoutesInformation.viewUser.name,
                //   pathParameters: {"user": entity.id},
                // );
              },
            );
          },
        ),

        if (state.event is DeviceLoadingEvent)
          SliverToBoxAdapter(child: PaginationFilter.render()),
        if (state.event is FetchSuccessEvent)
          SliverToBoxAdapter(
            child: PaginationFilter(
              maxPages: state.max,
              currentPage: state.filters.page,
              onPageSelect: (p) {
                Logger.d('Page changed -> $p', tag: 'Device PF');
                var bloc = context.read<DeviceBloc>();
                bloc.add(
                  UpdateDeviceFilters(
                    filters: bloc.state.filters.copyWith(
                      page: UpdateDeviceFilterTo(p),
                    ),
                  ),
                );
                // trigger search
                var a = context.read<AuthBloc>().state as AuthenticatedState;
                bloc.add(FetchDevicesEvent(token: a.token));
              },
            ),
          )
        else
          SliverToBoxAdapter(child: SizedBox.shrink()),
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

  void _onSearch() {
    var auth = context.read<AuthBloc>().state as AuthenticatedState;
    context.read<DeviceBloc>().add(FetchDevicesEvent(token: auth.token));
  }

  void _onSearchQueryChanged(String? q) {
    var bloc = context.read<DeviceBloc>();

    bloc.add(
      UpdateDeviceFilters(
        filters: bloc.state.filters.copyWith(query: UpdateDeviceFilterTo(q)),
      ),
    );
  }

  void _onDelete(String id) {
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
              var a = context.read<AuthBloc>().state as AuthenticatedState;
              var d = context.read<DeviceBloc>();

              d.add(DeleteDeviceEvent(token: a.token, id: id));
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
