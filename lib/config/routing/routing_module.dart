library;

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:moh_eam/config/logging/logger.dart';
import 'package:moh_eam/config/routing/_helpers/_routing_helpers_module.dart';
import 'package:moh_eam/config/routing/_routes/_routes_module.dart';
import 'package:moh_eam/features/error/ui/page.dart';
export '_helpers/_routing_helpers_module.dart';
export '_routes/_routes_module.dart';

abstract interface class AppRouterConfig {
  void init();
  Future<Map<String, String>> remoteAppConfiguration();
  Future<String?> globalRedirect(BuildContext context, GoRouterState state);
}

final class AppRouter implements AppRouterConfig {
  AppRouter._();

  static final _instance = AppRouter._();
  static AppRouter get instance => _instance;

  final String _initialPath = AppRoutesInformation.splash.path;

  final GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

  GoRouter get router {
    if (!_initialized) throw 'App Router Must be initialized';
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: _initialPath,
      redirect: globalRedirect,
      routes: AppRoutes.instance.appRoutes,
      errorBuilder: (context, state) {
        Logger.e(
          'Error occurred while navigating to ${state.matchedLocation}',
          tag: 'AppRouter-main[errorBuilder]',
        );
        return ErrorPage(
          onRetry: () => context.go(_initialPath),
          onGoHome: () => context.go('/'),
        );
      },
    );
  }

  bool _initialized = false;

  @override
  Future<void> init() async {
    // final configurations = await Future.wait([remoteAppConfiguration()]);
    GoRouter.optionURLReflectsImperativeAPIs = true;
    _initialized = true;
  }

  @override
  Future<Map<String, String>> remoteAppConfiguration() async {
    return {};
  }

  @override
  Future<String?> globalRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    Logger.d(
      'Client current page path is:\'${state.matchedLocation}\' an navigate to path:\'${state.fullPath}\'',
      tag: 'AppRouter-main[redirect]',
    );
    return null;
  }
}
