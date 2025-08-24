library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/routing/_helpers/_routing_helpers_module.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';
import 'package:moh_eam/config/utility/helpers/utility_helpers.dart';
import 'package:moh_eam/config/widget/widget_module.dart';
import 'package:moh_eam/core/bloc/global_bloc_module.dart';
import 'package:moh_eam/features/auth/bloc/auth_bloc.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String messageKey = 'splash_initializing';
  double progress = .1;
  void Function(BuildContext context, AuthState state) authListener =
      (BuildContext context, AuthState state) {};

  @override
  void initState() {
    super.initState();
    authListener = _listener;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _referesh();
      }
    });
  }

  void _referesh() {
    context.read<AuthBloc>().add(RefreshToken());
  }

  void _setMessageWithProgress(String key, double? add) {
    setState(() {
      messageKey = key;
      progress += add ?? 0;
    });
  }

  void _safeNavigation(String path) {
    if (!mounted) return;
    context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: _listener,
      child: ResponsiveScaffold(
        body: Column(
          spacing: context.responsive.spacing,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              AssetsHelper.mohLogo,
              height: context.responsive.responsive(
                mobile: 250,
                tablet: 260,
                desktop: 280,
                large: 300,
              ),
            ),
            Expanded(
              child: Text(
                textAlign: TextAlign.center,
                context.translate(key: 'splash_title'),
                style: context.h1!.copyWith(
                  fontSize: context.responsive.scale(30, .5),
                ),
              ),
            ),

            Column(
              spacing: 15,
              children: [
                Text(formate(context.translate(key: messageKey))),
                LinearProgressIndicator(value: progress),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    authListener = (context, state) {};
    super.dispose();
  }

  void _listener(BuildContext context, AuthState state) async {
    if (state.event is AuthPendingEvent) {
      if (mounted) {
        _setMessageWithProgress('splash_checking_auth', .2);
      }
      await Future.delayed(const Duration(seconds: 2));
      return;
    }

    if (state.event is AuthenticationSuccess) {
      _setMessageWithProgress('splash_authenticating', .2);

      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _setMessageWithProgress('splash_success', .5);
      }
      await Future.delayed(const Duration(seconds: 1));
      if (state.event is AuthenticationSuccess) {
        var a = state as AuthenticatedState;
        if (a.user.role == 'guest') {
          _safeNavigation(AppRoutesInformation.guestPage.path);
          return;
        }
        _safeNavigation(AppRoutesInformation.admin.path);
        return;
      }
      return;
    }

    if (state.event is AuthenticationFailed) {
      _setMessageWithProgress(state.event.message, 0);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _safeNavigation(AppRoutesInformation.signin.path);
      }
      return;
    }
  }

  String formate(String t) {
    var st = context.watch<AuthBloc>().state;
    if (st.event is! AuthenticationSuccess || st is! AuthenticatedState) {
      return t;
    }
    var lang = context.read<LanguageCubit>().state.languageCode;
    return t.replaceAll(
      '\$name',
      (lang == 'ar' ? st.user.fullNameAR : st.user.fullNameEN) ??
          st.user.username,
    );
  }
}
