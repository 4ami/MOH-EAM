part of '../page.dart';

enum GlassTexture { none, metal, sharp }

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.tint,
    this.blur = 8,
    this.texture = GlassTexture.none,
  });
  final Widget child;
  final double? width, height;
  final EdgeInsetsGeometry? padding, margin;
  final double blur;
  final Color? tint;
  final GlassTexture texture;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(
          context.responsive.borderRadius,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _bluredContainer(context),

            //Applay texture later
            if (padding != null)
              Padding(padding: padding!, child: child)
            else
              Padding(
                padding: EdgeInsetsGeometry.all(context.responsive.padding),
                child: child,
              ),
          ],
        ),
      ),
    );
  }

  BackdropFilter _bluredContainer(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.responsive.borderRadius),
          color: (tint ?? context.surfaceContainerHighest).withValues(
            alpha: .3,
          ),
          border: Border.all(color: context.outline.withValues(alpha: .15)),
          boxShadow: [
            BoxShadow(
              color: context.shadow.withValues(alpha: .08),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
      ),
    );
  }
}
