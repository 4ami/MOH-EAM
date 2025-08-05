part of 'extensions_module.dart';

extension TextStyleExtension on BuildContext {
  TextStyle? get h1 => Theme.of(
    this,
  ).textTheme.displayLarge; // !.copyWith(fontFamily: _fontFamily);
  TextStyle? get h2 => Theme.of(
    this,
  ).textTheme.displayMedium; // !.copyWith(fontFamily: _fontFamily);
  TextStyle? get h3 => Theme.of(
    this,
  ).textTheme.displaySmall; // !.copyWith(fontFamily: _fontFamily);
  TextStyle? get h4 => Theme.of(
    this,
  ).textTheme.headlineLarge; // !.copyWith(fontFamily: _fontFamily);
  TextStyle? get h5 => Theme.of(
    this,
  ).textTheme.headlineMedium; // !.copyWith(fontFamily: _fontFamily);
  TextStyle? get h6 => Theme.of(
    this,
  ).textTheme.headlineSmall; // !.copyWith(fontFamily: _fontFamily);

  TextStyle? get titleLarge => Theme.of(
    this,
  ).textTheme.titleLarge; // !.copyWith(fontFamily: _fontFamily);
  TextStyle? get titleMedium => Theme.of(
    this,
  ).textTheme.titleMedium; // !.copyWith(fontFamily: _fontFamily);
  TextStyle? get titleSmall => Theme.of(
    this,
  ).textTheme.titleSmall; // !.copyWith(fontFamily: _fontFamily);

  TextStyle? get bodyLarge => Theme.of(
    this,
  ).textTheme.bodyLarge; // !.copyWith(fontFamily: _fontFamily);
  TextStyle? get bodyMedium => Theme.of(
    this,
  ).textTheme.bodyMedium; // !.copyWith(fontFamily: _fontFamily);
  TextStyle? get bodySmall => Theme.of(
    this,
  ).textTheme.bodySmall; // !.copyWith(fontFamily: _fontFamily);

  TextStyle? get labelLarge => Theme.of(
    this,
  ).textTheme.labelLarge; // !.copyWith(fontFamily: _fontFamily);
  TextStyle? get labelMedium => Theme.of(
    this,
  ).textTheme.labelMedium; // !.copyWith(fontFamily: _fontFamily);
  TextStyle? get labelSmall => Theme.of(
    this,
  ).textTheme.labelSmall; // !.copyWith(fontFamily: _fontFamily);
}
