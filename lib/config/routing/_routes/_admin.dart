part of '_routes_module.dart';

final class _Admin implements _RouteInterface {
  const _Admin();

  @override
  GoRoute get page {
    return GoRoute(
      redirect: redirect,
      routes: subs,
      path: AppRoutesInformation.admin.path,
      name: AppRoutesInformation.admin.name,
      pageBuilder: (context, state) {
        return NoTransitionPage(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<DepartmentBloc>(create: (context)=> DepartmentBloc()),
              BlocProvider<AdminBloc>(
                create: (context) {
                  AdminBloc bloc = AdminBloc();
                  if (AuthorizationHelper.hasMinimumPermission(
                        context,
                        'devices',
                        "VIEW",
                      ) &&
                      AuthorizationHelper.hasMinimumPermission(
                        context,
                        'roles',
                        'VIEW',
                      )) {
                    return bloc..add(
                      AdminFetchDashboardEvent(
                        token:
                            (context.read<AuthBloc>().state
                                    as AuthenticatedState)
                                .token,
                      ),
                    );
                  }
                  return bloc;
                },
              ),
            ],
            child: AdminMain(),
          ),
        );
      },
    );
  }

  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    // return null; //Temporarly

    var authState = context.read<AuthBloc>().state;
    if (authState.event is! AuthenticationSuccess) {
      Logger.w(
        'Unauthorized attempt to access \'admin dashboard\'',
        tag: '[Admin-Redirect]',
      );
      return AppRoutesInformation.signin.path;
    }

    authState = authState as AuthenticatedState;
    var admins = ['super_admin', 'admin', 'moderator', 'system_admin'];
    if (admins.contains(authState.user.role)) {
      Logger.i(
        'Authorized access to \'admin dashboard\'',
        tag: '[Admin-Redirect]',
      );
      return null;
    }
    Logger.i(
      'None-admin access to \'admin dashboard\' - redirect to \'user dashboard\'',
      tag: '[Admin-Redirect]',
    );
    return AppRoutesInformation.signin.path;
  }

  @override
  List<RouteBase> get subs => [
    GoRoute(
      path: AppRoutesInformation.userManagement.path,
      name: AppRoutesInformation.userManagement.name,
      pageBuilder: (context, state) {
        return NoTransitionPage(
          child: BlocProvider<UserEntityBloc>(
            create: (context) {
              var auth = context.read<AuthBloc>().state as AuthenticatedState;
              return UserEntityBloc()
                ..add(UserEntityFetchUsersEvent(token: auth.token));
            },

            child: UsersView(),
          ),
        );
      },
      routes: [
        GoRoute(
          path: AppRoutesInformation.viewUser.path,
          name: AppRoutesInformation.viewUser.name,
          pageBuilder: (context, state) {
            if (state.pathParameters['user'] == null) {
              Logger.e(
                'User Details Viewer requires user id in path params',
                tag: 'UserDetailsViewer',
              );
              //redirect to ErrorPage
              return const NoTransitionPage(child: ErrorPage());
            }
            return NoTransitionPage(
              child: BlocProvider<UserEntityBloc>(
                create: (context) {
                  var auth =
                      context.read<AuthBloc>().state as AuthenticatedState;
                  var event = UserEntityFetchUserDetailsEvent(
                    token: auth.token,
                    userId: state.pathParameters['user']!,
                  );
                  return UserEntityBloc()..add(event);
                },

                child: const UserDetailsView(),
              ),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: AppRoutesInformation.departmentManagment.path,
      name: AppRoutesInformation.departmentManagment.name,
      pageBuilder: (context, state) {
        return NoTransitionPage(child: DepartmentsView());
      },
    ),

    GoRoute(
      path: AppRoutesInformation.devicesManagment.path,
      name: AppRoutesInformation.devicesManagment.name,
      pageBuilder: (context, state) {
        return NoTransitionPage(child: DevicesView());
      },
    ),
    _EntityViewerPage().page,
  ];
}
