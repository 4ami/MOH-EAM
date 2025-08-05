part of '../widget_module.dart';

//Modified for purpose later (IF NEEDED)
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.child,
    this.maxWidth,
    this.center = true,
  });

  final Widget child;
  final double? maxWidth;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final ResponsiveInfo info = context.responsive;
    Widget content = Container(
      constraints: BoxConstraints(maxWidth: maxWidth ?? info.maxContentWidth),
      child: child,
    );
    content = center && !info.isMobile ? Center(child: content) : content;
    return content;
  }
}
