part of '../widget_module.dart';

sealed class _ResponsiveBreakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double large = 1440;

  static DeviceType fromWidth({required double width}) {
    /// if the defiend size of mobile is greater than current width then it is a Mobile screen
    if (_ResponsiveBreakpoints.mobile > width) return DeviceType.mobile;

    /// if the defiend size of tablet is greater than current width then it is a Tablet screen
    if (_ResponsiveBreakpoints.tablet > width) return DeviceType.tablet;

    /// if the defiend size of desktop is greater than current width then it is a Desktop screen
    if (_ResponsiveBreakpoints.desktop > width) return DeviceType.desktop;

    /// if current width still greater the defiend sizes then it is Large Screen

    return DeviceType.large;
  }
}

enum DeviceType { mobile, tablet, desktop, large }

final class ResponsiveInfo {
  const ResponsiveInfo({
    required this.deviceType,
    required this.screenWidth,
    required this.screenHeight,
    required this.isPortrait,
    required this.columns,
    required this.padding,
    required this.spacing,
  });

  final DeviceType deviceType;
  final double screenWidth, screenHeight;
  final bool isPortrait;
  final int columns;
  final double padding, spacing;

  factory ResponsiveInfo.fromSize(Size size) {
    final double height = size.height, width = size.width;
    final bool isPortrait = height > width;
    final DeviceType type = _ResponsiveBreakpoints.fromWidth(width: width);

    final (int columns, double padding, double spacing) = switch (type) {
      DeviceType.mobile => (1, 16.0, 12.0),
      DeviceType.tablet => (2, 24.0, 16.0),
      DeviceType.desktop => (3, 32.0, 20.0),
      DeviceType.large => (4, 40.0, 24.0),
    };

    return ResponsiveInfo(
      deviceType: type,
      screenWidth: width,
      screenHeight: height,
      isPortrait: isPortrait,
      columns: columns,
      padding: padding,
      spacing: spacing,
    );
  }

  double width([double percentage = 1.0]) {
    final availableWidth = screenWidth - (padding * 2);
    return (availableWidth * percentage).clamp(0, maxContentWidth);
  }

  double height([double percentage = 1.0]) {
    final availableHeight = screenHeight - (padding * 2);
    return (availableHeight * percentage);
  }

  Size size([double widthPercentage = 1.0, double heightPercentage = 1.0]) {
    return Size(width(widthPercentage), height(heightPercentage));
  }

  Size sizeWithAspectRation({
    double widthPercentage = 1.0,
    double heightPercentage = 1.0,
    double aspectRatio = 1.0,
    bool fitWidth = true,
  }) {
    double maxWidth = width(widthPercentage),
        maxHeight = height(heightPercentage);

    if (!fitWidth) {
      double calculatedWidth = maxHeight * aspectRatio;
      return Size(
        calculatedWidth > maxWidth ? maxWidth : calculatedWidth,
        maxHeight,
      );
    }

    double calculatedHeight = maxWidth / aspectRatio;
    return Size(
      maxWidth,
      calculatedHeight > maxHeight ? maxHeight : calculatedHeight,
    );
  }

  T responsive<T>({required T mobile, T? tablet, T? desktop, T? large}) {
    return switch (deviceType) {
      DeviceType.mobile => mobile,
      DeviceType.tablet => tablet ?? mobile,
      DeviceType.desktop => desktop ?? tablet ?? mobile,
      DeviceType.large => large ?? desktop ?? tablet ?? mobile,
    };
  }

  double scale(double base, [double factor = 1.0]) {
    double multiplier = switch (deviceType) {
      DeviceType.mobile => 1.0,
      DeviceType.tablet => 1.2,
      DeviceType.desktop => 1.4,
      DeviceType.large => 1.6,
    };
    return base * multiplier * factor;
  }

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;
  bool get isLarge => deviceType == DeviceType.large;

  double get cardElevation => isMobile ? 2.0 : 4.0;
  double get borderRadius => isMobile ? 8.0 : 12.0;
  double get appBarHeight => isMobile ? 56.0 : 64.0;
  double get fabSize => isMobile ? 56.0 : 64.0;
  double get largeWidth => _ResponsiveBreakpoints.large;

  double get textScale => switch (deviceType) {
    DeviceType.mobile => 1.0,
    DeviceType.tablet => 1.1,
    DeviceType.desktop => 1.2,
    DeviceType.large => 1.3,
  };

  EdgeInsets get pagePadding => EdgeInsets.all(padding);
  EdgeInsets get cardPadding => EdgeInsets.all(padding * .75);
  double get maxContentWidth => switch (deviceType) {
    DeviceType.mobile => double.infinity,
    DeviceType.tablet => 600.0,
    DeviceType.desktop => 1200.0,
    DeviceType.large => 1600.0,
  };

  @override
  String toString() {
    return 'ResponsiveInfo(device: $deviceType, size: ${screenWidth.toInt()}x${screenHeight.toInt()}, columns: $columns)';
  }
}
