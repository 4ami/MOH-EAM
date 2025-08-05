part of 'admin_views_module.dart';

class DevicesView extends StatefulWidget {
  const DevicesView({super.key});

  @override
  State<DevicesView> createState() => _DevicesViewState();
}

class _DevicesViewState extends State<DevicesView> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: _appBar(context.isMobile),

      body: _layout(),
    );
  }

  Column _content() {
    return Column(children: [Text('Devices')]);
  }

  Widget _layout() {
    if (context.isMobile) return _content();
    return Row(
      children: [
        SideBar(),
        Expanded(child: _content()),
      ],
    );
  }

  AppBar _appBar(bool isMobile) {
    return AppBar(
      actionsPadding: EdgeInsets.symmetric(
        horizontal: context.responsive.padding,
        vertical: 10,
      ),
      actions: [
        if (!isMobile) ...[LanguageDropdown(), ThemeSwitcher()],
        Image.asset(
          AssetsHelper.mohLogoTextFree,
          scale: context.responsive.scale(15, .8),
        ),
      ],
    );
  }
}
