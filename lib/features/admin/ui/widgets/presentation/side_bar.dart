part of '../admin_widgets_module.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [BlocListener<AuthBloc, AuthState>(listener: _authListener)],

      child: _outerContainer(context),
    );
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state.event is SignoutAuthEvent && state is UnAuthenticatedState) {
      GoRouter.of(context).refresh();
      return;
    }
  }

  Column _content(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        SideBarItemContainer(
          onPressed: () {
            context.pushNamed(AppRoutesInformation.userManagement.name);
          },
          shrinked: Image.asset(
            AssetsHelper.usersIcon,
            scale: context.responsive.scale(30, .5),
          ),
          expanded: Text(
            context.translate(key: 'users_section'),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        SideBarItemContainer(
          onPressed: () {
            context.pushNamed(AppRoutesInformation.rolesManagment.name);
          },
          shrinked: Image.asset(
            AssetsHelper.rolesIcon,
            scale: context.responsive.scale(30, .5),
          ),
          expanded: Text(
            context.translate(key: 'roles_section'),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        SideBarItemContainer(
          onPressed: () {
            context.pushNamed(AppRoutesInformation.departmentManagment.name);
          },
          shrinked: Image.asset(
            AssetsHelper.departmentsIcon,
            scale: context.responsive.scale(30, .5),
          ),
          expanded: Text(
            context.translate(key: 'departments_section'),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        SideBarItemContainer(
          onPressed: () {
            context.pushNamed(AppRoutesInformation.devicesManagment.name);
          },
          shrinked: Image.asset(
            AssetsHelper.devicesIcon,
            scale: context.responsive.scale(30, .5),
          ),
          expanded: Text(
            context.translate(key: 'devices_section'),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
        // SideBarItemContainer(
        //   shrinked: Icon(Icons.support_agent_rounded),
        //   expanded: Text(
        //     context.translate(key: 'technical_support'),
        //     overflow: TextOverflow.ellipsis,
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        SideBarItemContainer(
          onPressed: () {
            context.read<AuthBloc>().add(SignoutAuthEvent());
          },
          fillColor: context.errorContainer.withValues(alpha: .5),
          shrinked: Icon(Icons.login_rounded),
          expanded: Text(
            context.translate(key: 'sign_out'),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Container _innerContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: _innerBoxDecoration(context),
      child: _content(context),
    );
  }

  Container _outerContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      constraints: BoxConstraints(
        maxWidth: context.responsive.scale(350, .5),
        minWidth: context.responsive.scale(150, .5),
      ),
      decoration: _outerBoxDecoration(context),
      child: _innerContainer(context),
    );
  }

  BoxDecoration _innerBoxDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(context.responsive.borderRadius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          context.surface.withAlpha(50),
          context.surfaceDim.withAlpha(100),
        ],
        stops: [0, .8],
      ),

      boxShadow: [
        BoxShadow(
          color: context.scrim.withAlpha(20),
          blurRadius: 25,
          blurStyle: BlurStyle.outer,
        ),
      ],
    );
  }

  BoxDecoration _outerBoxDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(context.responsive.borderRadius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          context.surface.withAlpha(100),
          context.surfaceTint.withAlpha(50),
        ],
      ),
      boxShadow: [
        BoxShadow(
          offset: -const Offset(5, 5),
          color: Colors.white.withAlpha(10),
          blurRadius: 10,
          blurStyle: BlurStyle.normal,
        ),
        BoxShadow(
          offset: const Offset(15, 15),
          color: context.shadow.withAlpha(20),
          blurRadius: 15,
          blurStyle: BlurStyle.normal,
          spreadRadius: 1,
        ),
      ],
    );
  }
}
