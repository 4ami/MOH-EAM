part of 'entity_widgets_module.dart';

class Header extends StatelessWidget {
  final String resourceName;
  const Header({super.key, required this.resourceName});

  static Widget render() => _HeaderShimmer();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: context.primary.withAlpha(10),
          child: Icon(Icons.info_outline, color: context.primary),
        ),
        Expanded(
          child: Text(
            context.translate(key: '${resourceName}_card_title'),
            style: context.h6!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _HeaderShimmer extends StatefulWidget {
  @override
  State<_HeaderShimmer> createState() => _HeaderShimmerState();
}

class _HeaderShimmerState extends State<_HeaderShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          spacing: 16,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _buildShimmerGradient(),
              ),
            ),
            Expanded(
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: _buildShimmerGradient(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  LinearGradient _buildShimmerGradient() {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: [0.0, 0.5, 1.0],
      colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
      transform: GradientRotation(_animation.value * 3.14159),
    );
  }
}
