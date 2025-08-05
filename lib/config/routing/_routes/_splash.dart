part of '_routes_module.dart';

final class _SplashRoute implements _RouteInterface {
  const _SplashRoute();
  @override
  GoRoute get page => GoRoute(
    path: AppRoutesInformation.splash.path,
    name: AppRoutesInformation.splash.name,
    pageBuilder: (context, state) {
      return NoTransitionPage(child: const Splash());
    },
    routes: subs,
    redirect: redirect,
  );

  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    return null;
  }

  @override
  List<RouteBase> get subs => [];
}
