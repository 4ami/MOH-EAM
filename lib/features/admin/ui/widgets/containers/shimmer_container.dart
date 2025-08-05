part of '../admin_widgets_module.dart';

class ShimmerContainer extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry? margin;
  final BorderRadius borderRadius;
  final double animationValue;

  const ShimmerContainer({
    super.key,
    required this.width,
    required this.height,
    this.margin,
    required this.borderRadius,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [
            (animationValue - 0.3).clamp(0.0, 1.0),
            (animationValue).clamp(0.0, 1.0),
            (animationValue + 0.3).clamp(0.0, 1.0),
          ],
          colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
        ),
      ),
    );
  }
}
