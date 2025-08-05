part of '../widget_module.dart';

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.childAspectRatio = 1.0,
  });

  final List<Widget> children;
  final double? crossAxisSpacing, mainAxisSpacing;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: info.columns,
            crossAxisSpacing: crossAxisSpacing ?? info.spacing,
            mainAxisSpacing: mainAxisSpacing ?? info.spacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: children.length,
          itemBuilder: (context, i) => children[i],
        );
      },
    );
  }
}
