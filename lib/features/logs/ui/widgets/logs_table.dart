part of 'logs_widgets_module.dart';

class LogsTable extends StatefulWidget {
  final List<LogEntity> logs;

  const LogsTable({super.key, required this.logs});

  static Widget render({int? rows, int? columns}) =>
      _LogsTableShimmer(rowCount: rows ?? 5, columnCount: columns ?? 5);

  @override
  State<LogsTable> createState() => _LogsTableState();
}

class _LogsTableState extends State<LogsTable> {
  final _scrollController = ScrollController();
  final List<String> _cols = [
    "movement_state",
    "action_by",
    "target_user",
    "note",
    "logged_at",
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.translate;

    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: context.surfaceContainer,
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: DataTable(
            border: TableBorder.all(color: context.primary.withAlpha(60)),
            dividerThickness: 1.5,
            columns: _cols
                .map((c) => DataColumn(label: SelectableText(t(key: c))))
                .toList(),
            rows: _buildRows(),
          ),
        ),
      ),
    );
  }

  List<DataRow> _buildRows() {
    var t = context.translate;
    if (widget.logs.isEmpty) return [];

    return List.generate(widget.logs.length, (i) {
      final log = widget.logs[i];
      final states = {
        'STORED': Colors.amber,
        'RETURNED': Colors.redAccent,
        'ASSIGNED': Colors.lightGreen,
        'UNASSIGNED': Colors.deepOrange,
      };
      return DataRow(
        cells: [
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: (states[log.state] ?? Colors.blueGrey).withValues(
                  alpha: 0.2,
                ), // lighter background
                borderRadius: BorderRadius.circular(50), // stadium shape
              ),
              child: SelectableText(
                t(key: log.state.toLowerCase()),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          DataCell(SelectableText(log.actionBy ?? '-')),
          DataCell(SelectableText(log.targetUser ?? '-')),
          DataCell(SelectableText(log.note ?? '-')),
          DataCell(
            SelectableText(
              log.loggedAtFormatted,
              textDirection: TextDirection.ltr,
            ),
          ),
        ],
      );
    });
  }
}

class _LogsTableShimmer extends StatefulWidget {
  final int rowCount;
  final int columnCount;

  const _LogsTableShimmer({this.rowCount = 5, this.columnCount = 5});

  @override
  State<_LogsTableShimmer> createState() => _LogsTableShimmerState();
}

class _LogsTableShimmerState extends State<_LogsTableShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(
      begin: -1,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Scrollbar(
          thumbVisibility: true,
          controller: _scrollController,
          child: Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: context.surfaceContainer,
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: DataTable(
                border: TableBorder.all(color: context.primary.withAlpha(30)),
                dividerThickness: 1.5,
                columns: _buildColumns(),
                rows: _buildRows(),
              ),
            ),
          ),
        );
      },
    );
  }

  List<DataColumn> _buildColumns() {
    return List.generate(widget.columnCount, (i) {
      return DataColumn(
        label: ShimmerContainer(
          width: 90 + (i * 15.0),
          height: 16,
          borderRadius: BorderRadius.circular(4),
          animationValue: _animation.value,
        ),
      );
    });
  }

  List<DataRow> _buildRows() {
    return List.generate(widget.rowCount, (i) {
      return DataRow(
        cells: List.generate(widget.columnCount, (j) {
          return DataCell(
            ShimmerContainer(
              width: 80 + (j * 10.0),
              height: 14,
              borderRadius: BorderRadius.circular(4),
              animationValue: _animation.value,
            ),
          );
        }),
      );
    });
  }
}
