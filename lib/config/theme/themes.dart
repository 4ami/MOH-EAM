part of 'theme_module.dart';

sealed class _AppThemeColors {
  static ColorScheme light = ColorScheme.fromSeed(
    seedColor: const Color(0xff008755),
    surface: const Color(0xffF5F5F5),
  );
  static ColorScheme dark = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color(0xff008755),
    surface: const Color(0xff2d2d2d),
  );
}

final class AppTheme {
  const AppTheme({required this.mode, required this.languageCode});

  final ThemeMode mode;
  final String languageCode;

  ThemeData get theme {
    ColorScheme colors = _colorScheme;
    return ThemeData(
      colorScheme: colors,
      brightness: colors.brightness,
      fontFamily: 'IBM_${languageCode.toUpperCase()}',
    );
  }

  ColorScheme get _colorScheme {
    if (mode == ThemeMode.system) {
      if (isLight) return _AppThemeColors.light;
      return _AppThemeColors.dark;
    }

    if (mode == ThemeMode.dark) return _AppThemeColors.dark;
    return _AppThemeColors.light;
  }

  bool get isLight {
    return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.light;
  }
}
