part of 'entity_widgets_module.dart';

class ExpansionItemOfList extends StatelessWidget {
  final String title;
  final List<dynamic> list;

  const ExpansionItemOfList({
    super.key,
    required this.title,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(vertical: 5),
      childrenPadding: const EdgeInsets.symmetric(vertical: 16),
      title: Text(
        context.translate(key: title),
        style: context.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
      ),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _buildChildren(context).toList(),
        ),
      ],
    );
  }

  Iterable<Widget> _buildChildren(BuildContext context) {
    return list.map<Widget>((perm) {
      final label = perm.toString().toUpperCase();

      Color chipColor;
      switch (label) {
        case 'CREATE':
          chipColor = Colors.green;
          break;
        case 'UPDATE':
          chipColor = Colors.orange;
          break;
        case 'DELETE':
          chipColor = Colors.red;
          break;
        case 'VIEW':
          chipColor = Colors.purple;
          break;
        default:
          chipColor = context.primary;
      }

      return FilterChip(
        label: Text(
          label,
          style: context.bodySmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        selected: true,
        onSelected: (_) {},
        selectedColor: chipColor.withAlpha(150),
        checkmarkColor: chipColor,
        side: BorderSide.none,
      );
    });
  }
}
