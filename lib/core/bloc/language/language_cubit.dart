part of '../global_bloc_module.dart';

Locale _kLang = Locale('ar');

final class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(_kLang) {
    call();
  }

  final List<String> _supportedLanguages = ['ar', 'en'];

  void call() {
    String lang = _get();
    emit(_safeLocale(lang));

    Logger.i('Initial language code: $lang', tag: 'Language[Cubit]');
  }

  void _set(String lang) {
    Logger.i('Set language code: $lang', tag: 'Language[Cubit]');
    final exp = DateTime.now().add(const Duration(days: 365));
    document.cookie = "lang=$lang; path=/; expires=${_rfc(exp.toUtc())}";
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

  String _get() {
    final cookies = document.cookie.split(';');
    for (var c in cookies) {
      var part = c.trim().split('=');
      if (part.length == 2 && part[0] == 'lang') return part[1];
    }
    _set('ar');
    return 'ar';
  }

  void toggle() {
    String current = state.languageCode;
    Logger.i('Toggle from language code: $current', tag: 'Language[Cubit]');

    String switchTo = current == 'ar' ? 'en' : 'ar';

    Logger.i('To language code: $switchTo', tag: 'Language[Cubit]');

    _set(switchTo);
    emit(Locale(switchTo));
  }

  Locale _safeLocale(String lang) {
    if (_supportedLanguages.contains(lang)) return Locale(lang);
    return Locale('ar');
  }

  void switchTo(Locale locale) {
    if (!_supportedLanguages.contains(locale.languageCode)) {
      return;
    }

    Logger.i(
      'Switch language code to: ${locale.languageCode}',
      tag: 'Language[Cubit]',
    );

    _set(locale.languageCode);
    emit(locale);
  }
}
