part of 'extensions_module.dart';

extension SnackBarExtensions on BuildContext {
  void showErrorSnackBar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: bodyLarge!.copyWith(fontWeight: FontWeight.bold, color: error),
        ),
        backgroundColor: errorContainer,
      ),
    );
  }

  void showSuccessSnackBar({required String message}) {
    ScaffoldMessenger.of(
      this,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: primary));
  }
}
