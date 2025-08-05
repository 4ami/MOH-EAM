part of 'admin_views_module.dart';

class DepartmentsView extends StatefulWidget {
  const DepartmentsView({super.key});

  @override
  State<DepartmentsView> createState() => _DepartmentsViewState();
}

class _DepartmentsViewState extends State<DepartmentsView> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: _appBar(context.isMobile),
      body: _layout(),
    );
  }

  Column _content() {
    return Column(children: [Text('Departments')]);
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
