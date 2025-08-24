part of 'users_widgets_module.dart';

class EditableTextField extends StatelessWidget {
  const EditableTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
  });
  final String? Function(String?)? validator;
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: context.translate(key: label),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
