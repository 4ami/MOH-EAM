part of 'entity_widgets_module.dart';

class MapView extends StatelessWidget {
  final Map<String, dynamic> value;
  const MapView({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: value.entries.map((entry) {
        final entryValue = entry.value;

        if (entryValue is List) {
          return ExpansionItemOfList(title: entry.key, list: entryValue);
        } else {
          return KeyValueRow(label: entry.key, value: entryValue);
        }
      }).toList(),
    );
  }
}
