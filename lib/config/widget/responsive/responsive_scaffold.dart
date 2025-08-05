part of '../widget_module.dart';

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    this.endDrawer,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.centered = true,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer, endDrawer, floatingActionButton, bottomNavigationBar;
  final Color? backgroundColor;
  final bool centered;

  PreferredSizeWidget _buildAppBar(ResponsiveInfo info) {
    return PreferredSize(
      preferredSize: Size.fromHeight(info.appBarHeight),
      child: appBar!,
    );
  }

  Widget? _buildFAB(ResponsiveInfo info) {
    if (floatingActionButton == null) return null;
    return SizedBox(
      width: info.fabSize,
      height: info.fabSize,
      child: floatingActionButton,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        Logger.i(
          'Responsive Scaffold built for [${info.deviceType}]',
          tag: 'Responsive[Scaffold]',
        );
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar != null ? _buildAppBar(info) : null,
          drawer: info.isMobile ? drawer : null,
          endDrawer: info.isMobile ? endDrawer : null,
          body: SafeArea(
            child: Padding(
              padding: context.pagePadding,
              child: ResponsiveLayout(center: centered, child: body),
            ),
          ),
          floatingActionButton: _buildFAB(info),
          bottomNavigationBar: info.isMobile ? bottomNavigationBar : null,
        );
      },
    );
  }
}
