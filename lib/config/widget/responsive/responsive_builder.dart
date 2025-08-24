part of '../widget_module.dart';

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({super.key, required this.builder, this.breakpoints});

  final Widget Function(BuildContext context, ResponsiveInfo info) builder;
  final Map<DeviceType, double>? breakpoints;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size size = Size(constraints.maxWidth, constraints.maxHeight);
        final ResponsiveInfo info = ResponsiveInfo.fromSize(size);

        return builder(context, info);
      },
    );
  }
}
