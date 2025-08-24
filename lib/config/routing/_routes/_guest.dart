part of '_routes_module.dart';

class _GuestRoute implements _RouteInterface {
  const _GuestRoute();

  @override
  GoRoute get page {
    return GoRoute(
      path: AppRoutesInformation.guestPage.path,
      name: AppRoutesInformation.guestPage.name,
      pageBuilder: (context, state) {
        return NoTransitionPage(
          child: BlocProvider<ProfileBloc>(
            create: (context) {
              var a = context.read<AuthBloc>().state as AuthenticatedState;
              return ProfileBloc()..add(GatherUserProfile(token: a.token));
            },
            child: GuestPage(),
          ),
        );
      },

      redirect: redirect,
      routes: subs,
    );
  }

  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    var authState = context.read<AuthBloc>().state;
    if (authState.event is! AuthenticationSuccess) {
      Logger.w(
        'Unauthorized attempt to access \'admin dashboard\'',
        tag: '[Admin-Redirect]',
      );
      return AppRoutesInformation.signin.path;
    }

    authState = authState as AuthenticatedState;

    if (authState.user.role == 'guest') {
      return null;
    }
    return AppRoutesInformation.signin.path;
  }

  @override
  List<RouteBase> get subs => [];
}
