part of 'extensions_module.dart';

extension LanguageExtension on BuildContext {
  String translate({
    required String key,
    bool useFallback = false,
    String fallback = '',
  }) {
    String t = LanguageHelper.of(this).fetch(key);
    if (useFallback && t == key) {
      t = LanguageHelper.of(this).fetch(fallback);
    }
    return t;
  }
}
