part of 'utility_helpers.dart';

class ValidationHelper {
  static String? username(String? u, BuildContext context) {
    if (u == null || u.isEmpty) return context.translate(key: 'field_required');
    if (u.length > 75) return context.translate(key: 'field_value_too_long');
    var regex = RegExp(r'^[A-Za-z0-9]+$');
    if (!regex.hasMatch(u)) {
      return context.translate(key: 'english_letters_numbers_policy');
    }
    return null;
  }

  static String? password(String? p, BuildContext context) {
    if (p == null || p.isEmpty) return context.translate(key: 'field_required');
    if (p.length < 8) return context.translate(key: 'password_length_policy');
    var letter = RegExp(r'[A-Za-z]');
    if (!letter.hasMatch(p)) {
      return context.translate(key: 'password_letters_policy');
    }
    var upperCase = RegExp(r'[A-Z]');
    if (!upperCase.hasMatch(p)) {
      return context.translate(key: 'password_uppercase_policy');
    }
    var twoDigits = RegExp(r'(?:\D*\d){2,}');
    if (!twoDigits.hasMatch(p)) {
      return context.translate(key: 'password_two_digits_policy');
    }
    var special = RegExp(r'[!@#\$%\^&\*\(\)_\+\=\-\.]');
    if (!special.hasMatch(p)) {
      return context.translate(key: 'password_special_policy');
    }
    return null;
  }
}
