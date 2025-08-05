part of '../admin_widgets_module.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({super.key, required this.child, this.animate = true});

  final Widget child;
  final bool animate;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // inner contaienr
    Widget inner = Container(
      // margin: const EdgeInsets.all(5),
      padding: EdgeInsets.all(context.responsive.padding),
      decoration: _inner(context),
      child: BackdropFilter(filter: ImageFilter.blur(), child: widget.child),
    );

    // Outer container
    Widget outer = Container(
      //outer decoration
      decoration: _outer(context),
      //outer child
      child: inner,
    );
    return MouseRegion(
      onEnter: (event) => _animationController.forward(),
      onExit: (event) => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(scale: _animation.value, child: child);
        },
        child: outer,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  BoxDecoration _inner(BuildContext context) {
    return BoxDecoration(
      color: context.surface,
      borderRadius: BorderRadius.circular(context.responsive.borderRadius),
      boxShadow: [
        _innerShadow(
          context.primary.withValues(alpha: .05),
          const Offset(0, 0),
        ),
        _innerShadow(
          context.surface.withValues(alpha: .2),
          -const Offset(0, 0),
        ),
      ],
    );
  }

  BoxShadow _innerShadow(Color color, Offset offset) {
    return BoxShadow(
      color: color,
      offset: offset,
      blurRadius: 15,
      blurStyle: BlurStyle.solid,
      spreadRadius: 4,
    );
  }

  BoxDecoration _outer(BuildContext context) {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(context.responsive.borderRadius),
      boxShadow: [
        _outerShadow(
          context.shadow.withValues(alpha: .15),
          const Offset(10, 10),
        ),
        _outerShadow(
          context.surfaceBright.withValues(alpha: .06),
          -const Offset(15, 15),
        ),
      ],
    );
  }

  BoxShadow _outerShadow(Color color, Offset offset) {
    return BoxShadow(
      blurRadius: 30,
      offset: offset,
      color: color,
      blurStyle: BlurStyle.normal,
    );
  }
}
