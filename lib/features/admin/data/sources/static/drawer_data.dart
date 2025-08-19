import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/routing/routing_module.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/config/widget/widget_module.dart';
import 'package:moh_eam/core/bloc/global_bloc_module.dart';
import 'package:moh_eam/features/admin/domain/entity/drawer_item.dart';
import 'package:moh_eam/features/admin/domain/entity/drawer_section.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';

class StaticDrawerData {
  const StaticDrawerData();

  static DrawerSectionEntity _systemPref(BuildContext context) {
    String mode = context.read<ThemeCubit>().isLight
        ? context.translate(key: 'light_mode')
        : context.translate(key: 'dark_mode');

    List<DrawerItemEntity> items = [
      DrawerItemEntity(
        itemLabel: context
            .translate(key: 'system_apperance')
            .replaceAll('\$mode', '\n$mode'),
        child: ThemeSwitcher(),
      ),
      DrawerItemEntity(
        itemLabel: context.translate(key: 'system_language'),
        child: LanguageDropdown(),
      ),
    ];

    return DrawerSectionEntity(
      sectionKey: 'system_prefrence_section',
      items: items,
    );
  }

  static DrawerSectionEntity _account(BuildContext context) {
    var auth = context.read<AuthBloc>().state as AuthenticatedState;
    var lang = context.read<LanguageCubit>().state.languageCode;

    String name =
        (lang == 'ar' ? auth.user.fullNameAR : auth.user.fullNameEN) ?? '';

    List<DrawerItemEntity> items = [
      DrawerItemEntity(
        itemLabel: context
            .translate(key: 'greeting_user')
            .replaceFirst(
              '\$name',
              name,
              // auth.user.fullNameAR ?? auth.user.fullNameEN ?? auth.user.role,
            ),
        highlight: true,
        child: Image.asset(
          AssetsHelper.wavingHandIcon,
          scale: context.responsive.scale(10, .8),
        ),
      ),
      // DrawerItemEntity(
      //   itemLabel: context.translate(key: 'user_profile'),
      //   child: Icon(Icons.account_circle_outlined),
      // ),
    ];

    return DrawerSectionEntity(
      sectionKey: 'user_account_section',
      items: items,
    );
  }

  static DrawerSectionEntity _systemSec(BuildContext context) {
    var child = Icon(Icons.adaptive.arrow_forward);
    List<DrawerItemEntity> items = [
      DrawerItemEntity(
        clickable: true,
        callback: () {
          context.pushNamed(AppRoutesInformation.userManagement.name);
        },
        itemLabel: context.translate(key: 'users_section'),
        child: child,
      ),
      DrawerItemEntity(
        clickable: true,
        callback: () {
          context.pushNamed(AppRoutesInformation.rolesManagment.name);
        },
        itemLabel: context.translate(key: 'roles_section'),
        child: child,
      ),
      DrawerItemEntity(
        clickable: true,
        callback: () {
          context.pushNamed(AppRoutesInformation.departmentManagment.name);
        },
        itemLabel: context.translate(key: 'departments_section'),
        child: child,
      ),
      DrawerItemEntity(
        clickable: true,
        callback: () {
          context.pushNamed(AppRoutesInformation.devicesManagment.name);
        },
        itemLabel: context.translate(key: 'devices_section'),
        child: child,
      ),
    ];
    return DrawerSectionEntity(sectionKey: 'system_sctions', items: items);
  }

  static List<Widget> build(BuildContext context) {
    var account = _account(context);
    var prefs = _systemPref(context);
    var sections = _systemSec(context);
    return [
      _buildSection(context, section: account.sectionKey),
      ...account.items.map((i) => _buildItem(context, item: i)),
      _buildSection(context, section: prefs.sectionKey),
      ...prefs.items.map((i) => _buildItem(context, item: i)),
      _buildSection(context, section: sections.sectionKey),
      ...sections.items.map((i) => _buildItem(context, item: i)),
      // _buildItem(
      //   context,
      //   item: DrawerItemEntity(
      //     itemLabel: context.translate(key: 'technical_support'),
      //     child: Icon(Icons.support_agent_rounded),
      //     highlight: true,
      //   ),
      // ),
      _signout(context),
      _end(context),
    ];
  }

  static Widget _buildSection(BuildContext context, {required String section}) {
    var text = Text(
      context.translate(key: section),
      style: context.titleLarge!.copyWith(
        fontSize: context.responsive.scale(20, .8),
        fontWeight: FontWeight.bold,
      ),
    );

    var divider = const Expanded(child: Divider());
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 15,
      children: [text, divider],
    );
  }

  static Widget _buildItem(
    BuildContext context, {
    required DrawerItemEntity item,
  }) {
    var labelText = Text(
      overflow: TextOverflow.ellipsis,
      item.itemLabel,
      style: context.titleMedium!.copyWith(
        fontSize: context.responsive.scale(!item.highlight ? 16 : 25, .8),
      ),
    );
    var expanded = Expanded(child: labelText);
    Widget drawerItem = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: context.responsive.scale(15, .8),
      children: [expanded, item.child],
    );

    if (item.clickable) {
      drawerItem = GestureDetector(onTap: item.callback, child: drawerItem);
    }

    if (item.highlight) {
      drawerItem = Container(
        decoration: BoxDecoration(
          color: context.secondaryContainer,
          borderRadius: BorderRadius.circular(context.responsive.padding),
        ),
        child: drawerItem,
      );
    }

    return drawerItem;
  }

  static Widget _signout(BuildContext context) {
    var labelText = Text(
      overflow: TextOverflow.ellipsis,
      context.translate(key: 'sign_out'),
      style: context.titleMedium!.copyWith(
        fontSize: context.responsive.scale(16, .8),
      ),
    );
    var expanded = Expanded(child: labelText);
    Widget drawerItem = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: context.responsive.scale(15, .8),
      children: [expanded, Icon(Icons.logout_rounded)],
    );

    drawerItem = Container(
      padding: context.responsive.cardPadding,
      decoration: BoxDecoration(
        color: context.errorContainer.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: drawerItem,
    );

    return drawerItem;
  }

  static Widget _end(BuildContext context) {
    var expanded = Expanded(child: const Divider());
    Widget drawerItem = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: context.responsive.scale(15, .8),
      children: [expanded, Text('MOH - EAM System'), expanded],
    );

    return drawerItem;
  }
}
