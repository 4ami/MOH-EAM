part of 'entity_widgets_module.dart';

class EntityActions extends StatelessWidget {
  final bool hasEdit;
  final bool hasDelete;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  const EntityActions({
    super.key,
    required this.hasEdit,
    required this.hasDelete,
    required this.onDelete,
    required this.onEdit,
  });

  static Widget render() =>
      _EntityActionsShimmer(hasEdit: true, hasDelete: true);

  @override
  Widget build(BuildContext context) {
    if (!hasEdit && !hasDelete) return const SizedBox.shrink();

    return Row(
      spacing: 16,
      children: [
        if (hasEdit)
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: context.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.edit_outlined),
              label: Text(context.translate(key: 'edit_action')),
              onPressed: onEdit,
            ),
          ),
        if (hasDelete)
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: context.error),
                foregroundColor: context.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.delete_forever_outlined),
              label: Text(context.translate(key: 'delete_action')),
              onPressed: onDelete,
            ),
          ),
      ],
    );
  }
}

class _EntityActionsShimmer extends StatefulWidget {
  final bool hasEdit;
  final bool hasDelete;

  const _EntityActionsShimmer({required this.hasEdit, required this.hasDelete});

  @override
  State<_EntityActionsShimmer> createState() => _EntityActionsShimmerState();
}

class _EntityActionsShimmerState extends State<_EntityActionsShimmer>
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
    if (!widget.hasEdit && !widget.hasDelete) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          spacing: 16,
          children: [
            if (widget.hasEdit)
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: _buildShimmerGradient(),
                  ),
                ),
              ),
            if (widget.hasDelete)
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
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
