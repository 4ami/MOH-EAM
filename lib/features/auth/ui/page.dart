library;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/routing/_helpers/_routing_helpers_module.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/config/widget/widget_module.dart';
import 'package:moh_eam/core/bloc/global_bloc_module.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';

part 'widgets/_signin_form.dart';
part 'widgets/glass_container.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: _listener,
      child: ResponsiveScaffold(
        appBar: AppBar(actions: [LanguageDropdown(), ThemeSwitcher()]),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              AssetsHelper.mohLogoTextFree,
              height: context.responsive.responsive(
                mobile: 250,
                tablet: 260,
                desktop: 280,
                large: 300,
              ),
            ),
            _SigninForm(key: null),
          ],
        ),
      ),
    );
  }

  void _listener(BuildContext context, AuthState state) {
    if (state.event is AuthenticationSuccess) {
      var a = state as AuthenticatedState;
      if (a.user.role == 'guest') {
        context.go(AppRoutesInformation.guestPage.path);
        return;
      }
      context.go(AppRoutesInformation.admin.path);
      return;
    }
  }
}
