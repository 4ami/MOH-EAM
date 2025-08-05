part of 'users_widgets_module.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    this.labelKey = 'save_changes',
    required this.onPressed,
  });
  final String labelKey;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.save_outlined),
      label: Text(
        context.translate(key: labelKey),
        textScaler: TextScaler.linear(.8),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
    );
  }
}
