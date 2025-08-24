part of 'guest_widget.dart';

class DepartmentCard extends StatelessWidget {
  const DepartmentCard({super.key, required this.department});
  final DepartmentEntity department;

  static Widget get render => _DepartmentCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
      padding: context.responsive.cardPadding,
      decoration: decoration(context),
      child: Column(
        children: [
          _buildDetail(context, 'id', department.id),
          _buildDetail(context, 'name', department.name),
          _buildDetail(context, 'level_name', department.levelName),
          _buildDetail(context, 'level', department.levelName),
          _buildDetail(context, 'parent_id', department.parentId ?? '-'),
        ],
      ),
    );
  }

  Row _buildDetail(BuildContext context, String label, String detail) {
    var t = context.translate;
    return Row(
      children: [
        SelectableText("${t(key: label)}: "),
        Expanded(child: SelectableText(detail)),
      ],
    );
  }

  BoxDecoration decoration(BuildContext context) {
    return BoxDecoration(
      color: context.surface,
      borderRadius: BorderRadius.circular(12),
      boxShadow: shadow(context),
    );
  }

  List<BoxShadow> shadow(BuildContext context) {
    var isLight = context.read<ThemeCubit>().isLight;
    return [
      BoxShadow(
        color: isLight
            ? Colors.grey.shade100.withAlpha(50)
            : context.shadow.withAlpha(50),
        blurRadius: 15,
        spreadRadius: .1,
        offset: -const Offset(5, 5),
        blurStyle: BlurStyle.inner,
      ),
      BoxShadow(
        color: context.shadow.withAlpha(10),
        blurRadius: 32,
        offset: const Offset(5, 5),
        blurStyle: BlurStyle.outer,
      ),
    ];
  }
}

class _DepartmentCardShimmer extends StatelessWidget {
  const _DepartmentCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
      padding: context.responsive.cardPadding,
      decoration: decoration(context),
      child: Column(
        children: List.generate(6, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 14,
                  decoration: _shimmerBox(context),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 14,
                    decoration: _shimmerBox(context),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  BoxDecoration decoration(BuildContext context) {
    return BoxDecoration(
      color: context.surface,
      borderRadius: BorderRadius.circular(12),
      boxShadow: shadow(context),
    );
  }

  List<BoxShadow> shadow(BuildContext context) {
    var isLight = context.read<ThemeCubit>().isLight;
    return [
      BoxShadow(
        color: isLight
            ? Colors.grey.shade100.withAlpha(50)
            : context.shadow.withAlpha(50),
        blurRadius: 15,
        spreadRadius: .1,
        offset: -const Offset(5, 5),
        blurStyle: BlurStyle.inner,
      ),
      BoxShadow(
        color: context.shadow.withAlpha(10),
        blurRadius: 32,
        offset: const Offset(5, 5),
        blurStyle: BlurStyle.outer,
      ),
    ];
  }

  BoxDecoration _shimmerBox(BuildContext context) {
    return BoxDecoration(
      color: context.shadow.withAlpha(30),
      borderRadius: BorderRadius.circular(8),
    );
  }
}
