import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/routing/_helpers/_routing_helpers_module.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/config/widget/widget_module.dart';
import 'package:moh_eam/features/admin/bloc/bloc.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({super.key});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    var t = context.translate;
    var w = context.read<AdminBloc>().state;

    if (w.event is! AdminGlobalSearchSuccess) {
      return const Center(child: CircularProgressIndicator());
    }

    var success = w.event as AdminGlobalSearchSuccess;

    return ResponsiveScaffold(
      appBar: _appBar(context.isMobile),
      body: SingleChildScrollView(
        child: Column(
          spacing: 12,
          children: [
            Text(t(key: 'result_in_users'), style: context.h5),
            if (success.users.isNotEmpty)
              _buildUsers(success)
            else
              Text(t(key: 'no_results'), style: context.h4),

            const Divider(),
            Text(t(key: 'result_in_devices'), style: context.h5),
            if (success.devices.isNotEmpty)
              _buildDevices(success)
            else
              Text(t(key: 'no_results'), style: context.h4),
          ],
        ),
      ),
    );
  }

  ListView _buildUsers(AdminGlobalSearchSuccess success) {
    return ListView.builder(
      itemCount: success.users.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: EntityCard(
            entity: success.users[i],
            onView: (entity) {
              context.pushNamed(
                AppRoutesInformation.viewUser.name,
                pathParameters: {"user": entity.id},
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDevices(AdminGlobalSearchSuccess success) {
    return ListView.builder(
      itemCount: success.devices.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: EntityCard(entity: success.devices[i]),
        );
      },
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
