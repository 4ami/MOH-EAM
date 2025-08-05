part of 'entity_widgets_module.dart';

class DetailItem extends StatelessWidget {
  final String label;
  final dynamic value;
  const DetailItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    Widget valueWidget;

    if (value is Map<String, dynamic>) {
      valueWidget = MapView(value: value);
    } else {
      valueWidget = SelectableText(
        value?.toString() ?? '-',
        style: context.bodyMedium,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          valueWidget,
        ],
      ),
    );
  }
}