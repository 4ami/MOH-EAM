part of 'extensions_module.dart';

extension ThemeColors on BuildContext {
  ColorScheme get _colorScheme => Theme.of(this).colorScheme;
  
  Color get scrim => _colorScheme.scrim;
  
  //Primary
  Color get primary => _colorScheme.primary;
  Color get primaryContainer => _colorScheme.primaryContainer;
  Color get primaryFixed => _colorScheme.primaryFixed;
  Color get primaryFixedDim => _colorScheme.primaryFixedDim;
  Color get inversePrimary => _colorScheme.inversePrimary;

  Color get onPrimary => _colorScheme.onPrimary;
  Color get onPrimaryContainer => _colorScheme.onPrimaryContainer;
  Color get onPrimaryFixed => _colorScheme.onPrimaryFixed;
  Color get onPrimaryFixedVariant => _colorScheme.onPrimaryFixedVariant;

  //Secondary
  Color get secondary => _colorScheme.secondary;
  Color get secondaryContainer => _colorScheme.secondaryContainer;
  Color get secondaryFixed => _colorScheme.secondaryFixed;
  Color get secondaryFixedDim => _colorScheme.secondaryFixedDim;

  Color get onSecondary => _colorScheme.onSecondary;
  Color get onSecondaryContainer => _colorScheme.onSecondaryContainer;
  Color get onSecondaryFixed => _colorScheme.onSecondaryFixed;
  Color get onSecondaryFixedVariant => _colorScheme.onSecondaryFixedVariant;

  //Surface
  Color get surface => _colorScheme.surface;
  Color get surfaceBright => _colorScheme.surfaceBright;
  Color get surfaceContainer => _colorScheme.surfaceContainer;
  Color get surfaceContainerHigh => _colorScheme.surfaceContainerHigh;
  Color get surfaceContainerHighest => _colorScheme.surfaceContainerHighest;
  Color get surfaceContainerLow => _colorScheme.surfaceContainerLow;
  Color get surfaceContainerLowest => _colorScheme.surfaceContainerLowest;
  Color get surfaceDim => _colorScheme.surfaceDim;
  Color get surfaceTint => _colorScheme.surfaceTint;
  Color get inverseSurface => _colorScheme.inverseSurface;

  Color get onSurface => _colorScheme.onSurface;
  Color get onSurfaceVariant => _colorScheme.onSurfaceVariant;
  Color get onInverseSurface => _colorScheme.onInverseSurface;

  //Error
  Color get error => _colorScheme.error;
  Color get errorContainer => _colorScheme.errorContainer;

  Color get onError => _colorScheme.onError;
  Color get onErrorContainer => _colorScheme.onErrorContainer;

  //Tertiary
  Color get tertiary => _colorScheme.tertiary;
  Color get tertiaryContainer => _colorScheme.tertiaryContainer;
  Color get tertiaryFixed => _colorScheme.tertiaryFixed;
  Color get tertiaryFixedDim => _colorScheme.tertiaryFixedDim;

  Color get onTertiary => _colorScheme.onTertiary;
  Color get onTertiaryContainer => _colorScheme.onTertiaryContainer;
  Color get onTertiaryFixed => _colorScheme.onTertiaryFixed;
  Color get onTertiaryFixedVariant => _colorScheme.onTertiaryFixedVariant;

  //Outline
  Color get outline => _colorScheme.outline;
  Color get outlineVariant => _colorScheme.outlineVariant;

  //Shadow
  Color get shadow => _colorScheme.shadow;
}
