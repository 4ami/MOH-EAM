part of '_routes_module.dart';

abstract interface class _RouteInterface {
  GoRoute get page;
  List<RouteBase> get subs;
  Future<String?> redirect(BuildContext context, GoRouterState state);
}