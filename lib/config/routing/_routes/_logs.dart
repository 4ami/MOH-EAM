part of '_routes_module.dart';

final class _LogsRoute implements _RouteInterface {
  const _LogsRoute();

  @override
  GoRoute get page {
    return GoRoute(
      redirect: redirect,
      routes: subs,
      path: AppRoutesInformation.logsPage.path,
      name: AppRoutesInformation.logsPage.name,
      pageBuilder: (context, state) {
        return NoTransitionPage(
          child: BlocProvider<LogsBloc>(
            create: (context) {
              var a = context.read<AuthBloc>().state as AuthenticatedState;
              return LogsBloc()..add(FetchLogsEvent(token: a.token));
            },
            child: LogsPage(),
          ),
        );
      },
    );
  }

  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    return null;
  }

  @override
  List<RouteBase> get subs => [];
}
