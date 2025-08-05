part of 'utility_helpers.dart';

/// Provides localization support using JSON-based language files.
///
/// Use [LanguageHelper.of(context)] to access localized strings via [fetch].

class LanguageHelper {
  /// Constructs a language helper for the given [locale].
  const LanguageHelper(this.locale);

  /// The current locale for this helper.
  final Locale locale;

  static late Map<String, String> _langDict;

  /// Loads the language dictionary from assets based on the locale.
  ///
  /// Must be awaited before using [fetch].
  Future<void> load() async {
    _langDict = await _Reader.instance.load(locale.languageCode);
  }

  /// Returns the localized string for the given [key].
  ///
  /// If the [key] is not found, it returns the [key] itself.
  String fetch(String key) => _langDict[key] ?? key;

  /// Retrieves the [LanguageHelper] from the widget tree.
  static LanguageHelper of(BuildContext context) {
    return Localizations.of(context, LanguageHelper)!;
  }
}

/// Singleton responsible for reading language files from assets.
///
/// Loads JSON files into a [Map<String, String>].
class _Reader {
  _Reader._();

  /// The path prefix to the language JSON files.
  final String _loc = 'lib/config/language';

  static final _Reader _instance = _Reader._();

  /// Accessor to the singleton instance.
  static _Reader get instance => _instance;

  /// [load] Loads and parses the language file for the given [langCode].
  ///
  /// Converts the JSON file into a [Map<String, String>].
  Future<Map<String, String>> load(String langCode) async {
    String json = await rootBundle.loadString('$_loc/$langCode.json');

    Map<String, dynamic> decoded = jsonDecode(json);

    return decoded.map((k, v) => MapEntry(k, v.toString()));
  }
}

/// A [LocalizationsDelegate] for the [LanguageHelper] class.
///
/// Registers this in your [MaterialApp] or [WidgetsApp] `localizationsDelegates`.
class LanguageDelegate extends LocalizationsDelegate<LanguageHelper> {
  /// Creates the delegate.
  LanguageDelegate();

  /// Languages currently supported: English (`en`) and Arabic (`ar`).
  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);

  /// Loads the [LanguageHelper] for the given [locale].
  @override
  Future<LanguageHelper> load(Locale locale) async {
    LanguageHelper helper = LanguageHelper(locale);
    await helper.load();
    return helper;
  }

  /// Returns whether the delegate should reload.
  ///
  /// In this implementation, always returns `false` since the delegate is stateless.
  @override
  bool shouldReload(covariant LocalizationsDelegate<LanguageHelper> old) =>
      false;
}
