part of '../admin_widgets_module.dart';

class DevicesPerTypeChart extends StatefulWidget {
  const DevicesPerTypeChart({super.key});

  @override
  State<DevicesPerTypeChart> createState() => _DevicesPerTypeChartState();
  static Widget render() => _DevicesPerTypeChartShimmer();
}

class _DevicesPerTypeChartState extends State<DevicesPerTypeChart> {
  late List<MapEntry> entries;


  List<Color> _buildThemeColors() {
    return List.generate(entries.length, (i) {
      // Generate evenly spaced hues around the color wheel
      double hue = (i * 360.0 / entries.length) % 360.0;
      return HSVColor.fromAHSV(1.0, hue, 0.7, 0.8).toColor();
    });
  }

  late List<Color> colors;
  late Map<String, Color> colorMap;

  @override
  void initState() {
    super.initState();

    entries = context.read<AdminBloc>().state.stats.entries.toList();
    colors = _buildThemeColors();
    colorMap = {
      for (int i = 0; i < entries.length; i++) entries[i].key: colors[i],
    };
  }

  Wrap _legend() {
    return Wrap(
      spacing: context.spacing,
      runSpacing: context.spacing,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      children: entries.map<Widget>((e) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: colorMap[e.key],
                // sshape: BoxShape.circle,
              ),
            ),
            SizedBox(
              child: Text(
                e.key,
                overflow: TextOverflow.fade,
                maxLines: 2,
                textScaler: TextScaler.linear(.7),
                softWrap: true,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      children: [
        SizedBox(
          width: context.responsive
              .sizeWithAspectRation(widthPercentage: .9)
              .width,
          height: context.responsive.height(.5),
          child: AspectRatio(
            aspectRatio: 1.66,
            child: BarChart(
              BarChartData(
                barTouchData: barTouchData,
                barGroups: _groupBuilder(),
                titlesData: _titlesData(),
              ),
            ),
          ),
        ),
        _legend(),
      ],
    );
  }

  List<BarChartGroupData>? _groupBuilder() {
    var groups = List.generate(entries.length, (i) {
      var entry = entries[i];
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            // color: context.primary,
            color: colorMap[entry.key],
            width: context.responsive.scale(20, .4),
          ),
        ],
      );
    });

    return groups;
  }

  BarTouchData get barTouchData {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (group) => context.secondaryContainer,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final label = entries[groupIndex].key;
          return BarTooltipItem('$label\n${rod.toY}', context.labelLarge!);
        },
      ),
    );
  }

  FlTitlesData _titlesData() {
    return FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}

class _DevicesPerTypeChartShimmer extends StatefulWidget {
  @override
  _DevicesPerTypeChartShimmerState createState() =>
      _DevicesPerTypeChartShimmerState();
}

class _DevicesPerTypeChartShimmerState
    extends State<_DevicesPerTypeChartShimmer>
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
        return Column(
          spacing: 15,
          children: [
            SizedBox(
              width: context.responsive
                  .sizeWithAspectRation(widthPercentage: .9)
                  .width,
              height: context.responsive.height(.5),
              child: AspectRatio(
                aspectRatio: 1.66,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [
                        (_animation.value - 0.3).clamp(0.0, 1.0),
                        (_animation.value).clamp(0.0, 1.0),
                        (_animation.value + 0.3).clamp(0.0, 1.0),
                      ],
                      colors: [
                        Colors.grey[300]!,
                        Colors.grey[100]!,
                        Colors.grey[300]!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(4, (index) {
                      double height = (index + 1) * 0.2 + 0.3;
                      return ShimmerContainer(
                        width: context.responsive.scale(20, .4),
                        height: context.responsive.height(.5) * height,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        borderRadius: BorderRadius.circular(4),
                        animationValue: _animation.value,
                      );
                    }),
                  ),
                ),
              ),
            ),
            // Legend shimmer
            _shimmerLegend(context),
          ],
        );
      },
    );
  }

  Widget _shimmerLegend(BuildContext context) {
    return Wrap(
      spacing: context.spacing,
      runSpacing: context.spacing,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      children: List.generate(4, (index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            ShimmerContainer(
              width: 12,
              height: 12,
              borderRadius: BorderRadius.circular(6),
              animationValue: _animation.value,
            ),
            ShimmerContainer(
              width: (60 + (index * 10))
                  .toDouble(), // Varying widths for realism
              height: 16,
              borderRadius: BorderRadius.circular(4),
              animationValue: _animation.value,
            ),
          ],
        );
      }),
    );
  }
}
