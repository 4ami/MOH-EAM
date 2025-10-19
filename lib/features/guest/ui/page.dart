import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/config/widget/widget_module.dart';
import 'package:moh_eam/core/bloc/global_bloc_module.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';
import 'package:moh_eam/features/guest/bloc/bloc.dart';
import 'package:moh_eam/features/guest/ui/widgets/guest_widget.dart';

class GuestPage extends StatefulWidget {
  const GuestPage({super.key});

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  @override
  Widget build(BuildContext context) {
    var t = context.translate;
    var w = context.watch<ProfileBloc>().state;
    return ResponsiveScaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(
          horizontal: context.responsive.padding,
          vertical: 10,
        ),
        leading: Image.asset(AssetsHelper.mohLogoTextFree),
        title: context.isTablet || context.isMobile
            ? null
            : Text(t(key: 'splash_title')),
        actions: [LanguageDropdown(), ThemeSwitcher()],
      ),
      body: _content(w),
    );
  }

  Widget _content(ProfileState sw) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _greeting()),
        SliverToBoxAdapter(child: SectionDivider(section: 'users_card_title')),
        ?_buildUserSection(sw),
        SliverToBoxAdapter(
          child: SectionDivider(section: 'devices_card_title'),
        ),
        ?_buildDeviceSection(sw),
        SliverToBoxAdapter(
          child: SectionDivider(section: 'departments_card_title'),
        ),
        ?_buildDepartmentSection(sw),
      ],
    );
  }

  Widget? _buildDeviceSection(ProfileState w) {
    if (w.event is ProfileLoadingEvent) {
      return SliverList.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return DeviceCard.render;
        },
      );
    }

    if (w.profile != null) {
      return SliverList.builder(
        itemCount: w.profile?.devices?.length,
        itemBuilder: (context, i) {
          return DeviceCard(device: w.profile!.devices![i]);
        },
      );
    }

    return null;
  }

  Widget? _buildDepartmentSection(ProfileState w) {
    if (w.profile != null) {
      if (w.profile?.department != null) {
        return SliverToBoxAdapter(
          child: DepartmentCard(department: w.profile!.department!),
        );
      }
    }
    return null;
  }

  Widget? _buildUserSection(ProfileState w) {
    if (w.event is ProfileLoadingEvent) {
      return SliverToBoxAdapter(child: UserCard.render);
    }
    if (w.profile != null) {
      return SliverToBoxAdapter(child: UserCard(user: w.profile!.user));
    }
    return null;
  }

  Row _greeting() {
    var t = context.translate;
    var a = context.read<AuthBloc>().state as AuthenticatedState;
    var name =
        (context.read<LanguageCubit>().state.languageCode == 'ar'
            ? a.user.fullNameAR
            : a.user.fullNameEN) ??
        a.user.username;
    return Row(
      children: [
        Text(
          t(key: 'greeting_user').replaceAll('\$name', name),
          style: context.h4,
        ),
      ],
    );
  }
}
