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

  static String? fullName(String? n, BuildContext context) {
    if (n == null || n.isEmpty || n.trim().isEmpty) {
      return context.translate(key: 'field_required');
    }
    var pattern = RegExp(r'^[A-Za-z\u0600-\u06FF\s]+$');
    if (!pattern.hasMatch(n) || n.length > 50) {
      return context.translate(key: 'full_name_invalid_fromat');
    }
    return null;
  }

  static String? email(String? e, BuildContext context) {
    if (e == null || e.isEmpty) return context.translate(key: 'field_required');
    if (e.length > 255) return context.translate(key: 'email_invalid_format');

    var pattern = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!pattern.hasMatch(e)) {
      return context.translate(key: 'email_invalid_format');
    }
    return null;
  }

  static String? mobile(String? m, BuildContext context) {
    if (m == null || m.isEmpty) return context.translate(key: 'field_required');
    if (m.length > 9) return context.translate(key: 'mobile_invalid_format');

    var pattern = RegExp(r'^\+?[0-9]\d{9,13}$');
    if (!pattern.hasMatch(m)) {
      return context.translate(key: 'mobile_invalid_format');
    }
    return null;
  }

  static String? confirmPassword(String? cp, String? p, BuildContext context) {
    var policyCheck = password(cp, context);
    if (policyCheck != null) return policyCheck;
    if (cp != p) {
      return context.translate(key: 'confirm_password_does_not_match');
    }
    return null;
  }
}
