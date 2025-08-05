part of '../global_bloc_module.dart';

final class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    call();
  }

  void call() {
    ThemeMode mode = _get();
    emit(mode);
    Logger.i('[call()] theme mode: $mode', tag: 'Theme[Cubit]');
  }

  void _set(ThemeMode mode) {
    Logger.i(
      'Set theme mode: ${mode.toString().split('.')[1]}',
      tag: 'Theme[Cubit]',
    );
    final exp = DateTime.now().add(const Duration(days: 365));
    document.cookie =
        "theme=${mode.toString().split('.')[1]}; path=/; expires=${_rfc(exp.toUtc())}";
  }

  ThemeMode _get() {
    final cookies = document.cookie.split(';');
    String stored = '';
    for (var c in cookies) {
      var part = c.trim().split('=');
      if (part.length == 2 && part[0] == 'theme') {
        stored = part[1];
        break;
      }
    }
    ThemeMode mode = stored == 'light'
        ? ThemeMode.light
        : (stored == 'dark')
        ? ThemeMode.dark
        : ThemeMode.system;
    _set(mode);
    return mode;
  }

  String _rfc(DateTime t) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final weekday = weekdays[t.weekday % 7];
    final day = t.day.toString().padLeft(2, '0');
    final month = months[t.month - 1];
    final year = t.year;
    final hour = t.hour.toString().padLeft(2, '0');
    final minute = t.minute.toString().padLeft(2, '0');
    final second = t.second.toString().padLeft(2, '0');

    return '$weekday, $day $month $year $hour:$minute:$second GMT';
  }

  void toggle() {
    ThemeMode current = state, to = ThemeMode.system;
    Logger.i('Toggle from theme mode: $current', tag: 'Theme[Cubit]');

    switch (current) {
      case ThemeMode.light:
        {
          to = ThemeMode.dark;
          break;
        }
      case ThemeMode.dark:
        {
          to = ThemeMode.light;
          break;
        }
      case ThemeMode.system:
        {
          to = isLight ? ThemeMode.dark : ThemeMode.light;
          break;
        }
    }
    Logger.i('To theme mode: $to', tag: 'Theme[Cubit]');
    _set(to);
    emit(to);
  }

  bool get isLight {
    bool system =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.light;
    return state == ThemeMode.system ? system : _isLight;
  }

  bool get _isLight {
    return state == ThemeMode.light;
  }
}

// Could add enum extension for cleaner code
extension ThemeModeExtension on ThemeMode {
  String get cookieValue => toString().split('.')[1];

  static ThemeMode fromCookieValue(String value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
