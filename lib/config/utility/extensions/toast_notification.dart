part of 'extensions_module.dart';

extension CustomToasts on BuildContext {
  ToastificationItem errorToast({
    required String title,
    required String description,
  }) {
    return toastification.show(
      autoCloseDuration: const Duration(seconds: 5),
      context: this,
      title: Text(
        title,
        style: titleMedium!.copyWith(
          color: errorColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(description),
      primaryColor: errorColor,
      backgroundColor: errorContainer,
      foregroundColor: errorColor,
      style: ToastificationStyle.flatColored,
      icon: Icon(Icons.error_rounded),
    );
  }

  ToastificationItem successToast({
    required String title,
    required String description,
  }) {
    return toastification.show(
      autoCloseDuration: const Duration(seconds: 5),
      context: this,
      title: Text(
        title,
        style: titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
      description: Text(description),
      style: ToastificationStyle.flatColored,
    );
  }

  ToastificationItem warningToast({
    required String title,
    required String description,
  }) {
    return toastification.show(
      autoCloseDuration: const Duration(seconds: 5),
      context: this,
      title: Text(
        title,
        style: titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.deepOrangeAccent,
        ),
      ),
      description: Text(description),
      primaryColor: Colors.deepOrangeAccent,
      style: ToastificationStyle.flatColored,
      icon: Icon(Icons.warning_amber_rounded, color: Colors.deepOrangeAccent),
    );
  }
}
