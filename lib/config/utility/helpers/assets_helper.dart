part of 'utility_helpers.dart';

sealed class AssetsHelper {
  static final String _rootImages = 'assets/images';

  static String get mohLogo => '$_rootImages/moh_logo.png';
  static String get mohLogoTextFree => '$_rootImages/moh_logo_text_free.png';

  static final String _rootIcons = 'assets/icons';
  static String get devicesIcon => '$_rootIcons/devices.png';
  static String get departmentsIcon => '$_rootIcons/departments.png';
  static String get usersIcon => '$_rootIcons/users.png';
  static String get rolesIcon => '$_rootIcons/roles.png';
  static String get wavingHandIcon => '$_rootIcons/waving_hand.png';

  static final String _rootFonts = 'assets/fonts';
  static String get unknown => _rootFonts;
}
