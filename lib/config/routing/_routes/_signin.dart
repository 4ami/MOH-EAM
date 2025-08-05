part of '_routes_module.dart';

class _SigninRoute implements _RouteInterface {
  const _SigninRoute();
  @override
  GoRoute get page => GoRoute(
    path: AppRoutesInformation.signin.path,
    name: AppRoutesInformation.signin.name,
    routes: subs,
    redirect: redirect,
    pageBuilder: (context, state) {
      context.read<AuthBloc>().add(UsernameChanged(username: ''));
      return NoTransitionPage(child: SigninPage());
    },
  );

  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    return null;
  }

  @override
  List<RouteBase> get subs => [];
}
