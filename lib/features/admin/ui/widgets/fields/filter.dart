part of '../admin_widgets_module.dart';

class Filter extends StatelessWidget {
  final String? resource;
  const Filter({super.key, required this.resource});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.responsive.width(.5),
      child: ExpansionTile(
        shape: BeveledRectangleBorder(),
        title: Text(context.translate(key: 'search_filter')),
        leading: Icon(Icons.filter_alt_rounded),
        children: [_buildFilter],
      ),
    );
  }

  Widget get _buildFilter {
    return switch (resource) {
      'users' => const UserFilter(),
      _ => SizedBox.shrink(),
    };
  }
}
