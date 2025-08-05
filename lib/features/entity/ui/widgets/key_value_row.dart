part of 'entity_widgets_module.dart';

class KeyValueRow extends StatelessWidget {
  final String label;
  final dynamic value;
  const KeyValueRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: SelectableText(
              context.translate(key: label),
              style: context.bodySmall!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SelectableText(
              value is Map
                  ? (value as Map).isEmpty
                        ? '-'
                        : value.toString()
                  : value?.toString() ?? '-',
              style: context.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
