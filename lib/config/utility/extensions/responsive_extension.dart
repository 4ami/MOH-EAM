part of 'extensions_module.dart';

extension ResponsiveContextExtension on BuildContext {
  ResponsiveInfo get responsive {
    final Size size = MediaQuery.sizeOf(this);
    return ResponsiveInfo.fromSize(size);
  }

  bool get isMobile => responsive.isMobile;
  bool get isTablet => responsive.isTablet;
  bool get isDesktop => responsive.isDesktop;
  bool get isLarge => responsive.isLarge;

  double get spacing => responsive.spacing;
  double get padding => responsive.padding;
  EdgeInsets get pagePadding => responsive.pagePadding;

  int get columns => responsive.columns;

  double get textScale => responsive.textScale;
}
