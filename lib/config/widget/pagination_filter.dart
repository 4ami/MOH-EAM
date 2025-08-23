import 'package:flutter/material.dart';
import 'package:moh_eam/config/utility/extensions/extensions_module.dart';

class PaginationFilter extends StatefulWidget {
  final int maxPages;
  final int currentPage;
  final Function(int) onPageSelect;

  const PaginationFilter({
    super.key,
    required this.maxPages,
    required this.currentPage,
    required this.onPageSelect,
  });

  @override
  State<PaginationFilter> createState() => _PaginationFilterState();

  static Widget render() => _PaginationFilterShimmer();
}

class _PaginationFilterState extends State<PaginationFilter> {
  @override
  Widget build(BuildContext context) {
    if (widget.maxPages < 1) return const SizedBox.shrink();

    return FittedBox(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            // Previous button
            _buildNavigationButton(
              icon: Icons.chevron_left,
              onTap: widget.currentPage > 1
                  ? () => widget.onPageSelect(widget.currentPage - 1)
                  : null,
            ),

            // Page numbers
            ..._buildPageNumbers(),

            // Next button
            _buildNavigationButton(
              icon: Icons.chevron_right,
              onTap: widget.currentPage < widget.maxPages
                  ? () => widget.onPageSelect(widget.currentPage + 1)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton({required IconData icon, VoidCallback? onTap}) {
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isEnabled ? context.surface : context.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: context.shadow.withAlpha(100),
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                  ),
                  BoxShadow(
                    color: context.surface,
                    offset: const Offset(-4, -4),
                    blurRadius: 8,
                  ),
                ]
              : [
                  BoxShadow(
                    color: context.shadow.withAlpha(20),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                  BoxShadow(
                    color: context.surface.withAlpha(100),
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                  ),
                ],
        ),
        child: Icon(
          icon,
          color: isEnabled ? context.onSurface : context.onSurfaceVariant,
          size: 20,
        ),
      ),
    );
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> pages = [];

    // Calculate visible page range
    int start = 1;
    int end = widget.maxPages;

    if (widget.maxPages > 7) {
      if (widget.currentPage <= 4) {
        end = 7;
      } else if (widget.currentPage >= widget.maxPages - 3) {
        start = widget.maxPages - 6;
      } else {
        start = widget.currentPage - 3;
        end = widget.currentPage + 3;
      }
    }

    // First page
    if (start > 1) {
      pages.add(_buildPageButton(1));
      if (start > 2) {
        pages.add(_buildEllipsis());
      }
    }

    // Visible pages
    for (int i = start; i <= end; i++) {
      pages.add(_buildPageButton(i));
    }

    // Last page
    if (end < widget.maxPages) {
      if (end < widget.maxPages - 1) {
        pages.add(_buildEllipsis());
      }
      pages.add(_buildPageButton(widget.maxPages));
    }

    return pages
        .map(
          (page) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: page,
          ),
        )
        .toList();
  }

  Widget _buildPageButton(int pageNumber) {
    final isSelected = pageNumber == widget.currentPage;

    return GestureDetector(
      onTap: () => widget.onPageSelect(pageNumber),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? context.primary : context.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.primary.withAlpha(60),
                    offset: const Offset(4, 4),
                    blurRadius: 12,
                  ),
                  BoxShadow(
                    color: context.surface,
                    offset: const Offset(-4, -4),
                    blurRadius: 12,
                  ),
                ]
              : [
                  BoxShadow(
                    color: context.shadow.withAlpha(40),
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                  ),
                  BoxShadow(
                    color: context.surface,
                    offset: const Offset(-4, -4),
                    blurRadius: 8,
                  ),
                ],
        ),
        child: Center(
          child: Text(
            pageNumber.toString(),
            style: context.bodyMedium!.copyWith(
              color: isSelected ? context.onPrimary : context.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          '...',
          style: context.bodyMedium!.copyWith(
            color: context.onSurfaceVariant,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _PaginationFilterShimmer extends StatefulWidget {
  @override
  State<_PaginationFilterShimmer> createState() =>
      _PaginationFilterShimmerState();
}

class _PaginationFilterShimmerState extends State<_PaginationFilterShimmer>
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous button shimmer
              _buildShimmerButton(),
              const SizedBox(width: 8),
              // Page numbers shimmer
              ...List.generate(
                5,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: _buildShimmerButton(),
                ),
              ),
              const SizedBox(width: 8),
              // Next button shimmer
              _buildShimmerButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildShimmerButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: _buildShimmerGradient(),
      ),
    );
  }

  LinearGradient _buildShimmerGradient() {
    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: const [0.0, 0.5, 1.0],
      colors: [
        context.surfaceContainer,
        context.surface,
        context.surfaceContainer,
      ],
      transform: GradientRotation(_animation.value * 3.14159),
    );
  }
}
