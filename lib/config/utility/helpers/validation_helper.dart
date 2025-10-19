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

  static String? fullName(
    String? n,
    BuildContext context, {
    required bool? isAr,
  }) {
    if (n == null || n.isEmpty || n.trim().isEmpty) {
      return context.translate(key: 'field_required');
    }

    if (n.length > 50) {
      return context.translate(key: 'field_value_too_long');
    }

    RegExp pattern;

    if (isAr != null) {
      if (isAr) {
        pattern = RegExp(r'^[\u0600-\u06FF\s]+$');
      } else {
        pattern = RegExp(r'^[A-Za-z\s]+$');
      }
    } else {
      pattern = RegExp(r'^[A-Za-z\u0600-\u06FF\s]+$');
    }

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
    if (m.length > 10) return context.translate(key: 'mobile_invalid_format');

    var pattern = RegExp(r'^05\d{8}$');
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

  static String? dropDown<V extends Object>(V? value, BuildContext context) {
    if (value == null) return context.translate(key: 'field_required');
    if (value.toString().isEmpty) {
      return context.translate(key: 'field_required');
    }
    return null;
  }

  static String? name(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.translate(key: 'field_required');
    }

    var pattern = r'^(?!.*__)(?![_\s])[A-Za-z0-9\u0600-\u06FF _]+(?<![_\s])$';
    if (!RegExp(pattern).hasMatch(value)) {
      return context.translate(key: 'full_name_invalid_fromat');
    }

    return null;
  }

  static String? serial(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.translate(key: 'field_required');
    }

    var pattern = r'^[a-zA-Z0-9]+(-[a-zA-Z0-9]+)*$';

    if (!RegExp(pattern).hasMatch(value)) {
      return context.translate(key: 'invalid_format');
    }

    if (value.length > 255) {
      return context.translate(key: 'field_value_too_long');
    }

    return null;
  }

  static String? model(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.translate(key: 'field_required');
    }
    if (value.length > 255) {
      return context.translate(key: 'field_value_too_long');
    }
    return null;
  }

  static String? type(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return context.translate(key: 'field_required');
    }

    if (value.length > 100) {
      return context.translate(key: 'field_value_too_long');
    }

    return null;
  }

  static String? hostName(String? value, BuildContext context) {
    if (value != null && value.length > 100) {
      return context.translate(key: 'field_value_too_long');
    }

    return null;
  }

  static String? movementNote(String? value, BuildContext context) {
    if (value == null || value.isEmpty) return null;
    var pattern = r'^(?!.*__)(?![_\s])[A-Za-z0-9\u0600-\u06FF _]+(?<![_\s])$';
    if (!RegExp(pattern).hasMatch(value)) {
      return context.translate(key: 'note_invalid_fromat');
    }
    return null;
  }
}
