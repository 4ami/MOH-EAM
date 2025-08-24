part of 'guest_widget.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key, required this.section});
  final String section;
  @override
  Widget build(BuildContext context) {
    var t = context.translate;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Expanded(child: Divider(endIndent: 15)),
        Text(t(key: section)),
        const Expanded(child: Divider(indent: 15)),
      ],
    );
  }
}
