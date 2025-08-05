part of '_routes_module.dart';

class _EntityViewerPage implements _RouteInterface {
  const _EntityViewerPage();

  @override
  GoRoute get page => GoRoute(
    path: AppRoutesInformation.entityViewer.path,
    name: AppRoutesInformation.entityViewer.name,
    routes: subs,
    pageBuilder: (context, state) {
      Logger.w(
        'Navigating to EntityViewerPage with state: ${state.matchedLocation}, extra: ${state.extra}, pathParameters: ${state.pathParameters}',
        tag: 'EntityViewerPage',
      );
      if (state.extra == null || state.extra is! EntityModel) {
        Logger.e(
          'EntityViewerPage requires an EntityModel in extra',
          error: state.extra.toString(),
          tag: 'EntityViewerPage',
        );
        //redirect to ErrorPage
        return const NoTransitionPage(child: ErrorPage());
      }
      var entity = state.extra as EntityModel;
      return NoTransitionPage(child: EntityViewerPage(entity: entity));
    },
  );

  @override
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    return null;
  }

  @override
  List<RouteBase> get subs => [
    GoRoute(
      name: AppRoutesInformation.editUser.name,
      path: AppRoutesInformation.editUser.path,
      pageBuilder: (context, state) {
        Logger.w(
          'Navigating to EditUserPage with state: ${state.matchedLocation}, extra: ${state.extra}, pathParameters: ${state.pathParameters}',
          tag: 'EditUserPage',
        );
        if (state.extra == null || state.extra is! UserEntity) {
          Logger.e(
            'EditUserPage requires a UserEntity in extra',
            error: state.extra.toString(),
            tag: 'EditUserPage',
          );
          //redirect to ErrorPage
          return const NoTransitionPage(child: ErrorPage());
        }
        var userEntity = state.extra as UserEntity;
        return NoTransitionPage(child: EditUserPage(userEntity: userEntity));
      },
    ),
  ];
}
