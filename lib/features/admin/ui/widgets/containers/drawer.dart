part of '../admin_widgets_module.dart';

class AdminDrawerBody extends StatelessWidget {
  const AdminDrawerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.responsive.pagePadding,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 25,
          children: StaticDrawerData.build(context),
        ),
      ),
    );
  }
}
