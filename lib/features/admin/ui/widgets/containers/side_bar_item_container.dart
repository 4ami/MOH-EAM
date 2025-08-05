part of '../admin_widgets_module.dart';

class SideBarItemContainer extends StatefulWidget {
  const SideBarItemContainer({
    super.key,
    required this.shrinked,
    required this.expanded,
    this.fillColor,
    this.onPressed,
  });

  final Widget shrinked, expanded;
  final Color? fillColor;
  final VoidCallback? onPressed;

  double get _min => 80;
  double get _max => 150;

  @override
  State<SideBarItemContainer> createState() => _SideBarItemContainerState();
}

class _SideBarItemContainerState extends State<SideBarItemContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool hover = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: MouseRegion(
        opaque: true,
        onEnter: _onEnter,
        onExit: _onExit,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: hover ? widget._max : widget._min,
          height: 50,
          decoration: BoxDecoration(
            color: widget.fillColor ?? context.surface,
            borderRadius: BorderRadius.circular(
              context.responsive.borderRadius,
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: context.inverseSurface.withAlpha(20),
            //     blurRadius: 10,
            //     blurStyle: BlurStyle.outer,
            //   ),
            // ],
          ),
          child: hover
              ? FadeTransition(
                  opacity: _fadeAnimation,
                  child: Center(child: widget.expanded),
                )
              : widget.shrinked,
        ),
      ),
    );
  }

  void _onExit(PointerExitEvent event) {
    setState(() {
      hover = false;
      _controller.reverse();
    });
  }

  void _onEnter(PointerEnterEvent event) {
    setState(() {
      hover = true;
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
