part of 'widget_module.dart';

class EntityTable<T extends EntityModel> extends StatefulWidget {
  final List<T> entities;
  final List<String> tableCols;
  final bool showMore;
  final bool edit;
  final bool delete;
  final void Function(T entity)? onUpdate;
  final void Function(T entity)? onDelete;
  final void Function(T entity)? onView;

  const EntityTable({
    super.key,
    required this.entities,
    required this.tableCols,
    this.onUpdate,
    this.onDelete,
    this.onView,
    this.showMore = true,
    this.edit = false,
    this.delete = false,
  });

  @override
  State<EntityTable<T>> createState() => _EntityTableState<T>();
  static Widget render({int? rows, int? columns}) =>
      _EntityTableShimmer(rowCount: rows ?? 5, columnCount: columns ?? 5);
}

class _EntityTableState<T extends EntityModel> extends State<EntityTable<T>> {
  late List<bool> _isSelected;
  late List<String> _columns;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.entities.isNotEmpty) {
      _isSelected = List.filled(widget.entities.length, false);
    } else {
      _isSelected = [];
    }
    _columns = widget.tableCols;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: _boxDecoration(context),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: DataTable(
            onSelectAll: _onSelectAll,
            border: TableBorder.all(color: context.primary),
            dividerThickness: 2,
            columns: _buildCols(),
            rows: _buildRow(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  BoxDecoration _boxDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      color: context.surfaceContainer,
    );
  }

  void _onSelectAll(bool? b) {
    if (b == null) return;
    setState(() {
      _isSelected = List.filled(widget.entities.length, b);
    });
  }

  List<DataColumn> _buildCols() {
    var cols = List.generate(_columns.length, (i) {
      return DataColumn(
        label: SelectableText(context.translate(key: _columns[i])),
      );
    });
    if (widget.delete) {
      cols = cols
        ..add(
          DataColumn(
            label: SelectableText(context.translate(key: 'delete_action')),
          ),
        );
    }
    if (widget.edit) {
      return cols..add(
        DataColumn(
          label: SelectableText(context.translate(key: 'edit_action')),
        ),
      );
    }
    return widget.showMore
        ? (cols..add(
            DataColumn(
              label: SelectableText(context.translate(key: 'show_more')),
            ),
          ))
        : cols;
  }

  List<DataRow> _buildRow() {
    if (widget.entities.isEmpty) return [];
    return List.generate(widget.entities.length, (i) {
      var row = widget.entities[i].toTableRow();
      return DataRow(
        selected: _isSelected[i],
        onSelectChanged: (value) {
          if (value == null) return;
          setState(() {
            _isSelected[i] = value;
          });
        },
        cells: _buildCells(row, i),
      );
    });
  }

  List<DataCell> _buildCells(Map<String, dynamic> row, int index) {
    var cells = List.generate(_columns.length, (j) {
      var cell = row[_columns[j]];
      if (cell == null) {
        return DataCell(SelectableText('N/A'));
      }

      if (cell is String && cell.isEmpty) {
        return DataCell(SelectableText('-'));
      }
      if (cell is bool && _columns[j].startsWith('is')) {
        bool value = cell;
        String state = context.translate(key: '${value}_state');
        return DataCell(
          SelectableText(
            state,
            style: context.bodyLarge!.copyWith(
              color: value ? Colors.greenAccent : context.error,
            ),
          ),
        );
      }
      return DataCell(SelectableText(cell.toString()));
    });

    if (widget.delete) {
      cells = cells..add(_deleteRecord(row, index));
    }

    if (widget.edit) {
      return cells..add(_editRecord(row, index));
    }

    return widget.showMore ? (cells..add(_showMore(row, index))) : cells;
  }

  DataCell _showMore(Map<String, dynamic> entity, int index) {
    return DataCell(
      TextButton.icon(
        label: Text(context.translate(key: 'show_more_details')),
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          if (AuthorizationHelper.hasMinimumPermission(
            context,
            widget.entities[index].resourceName,
            'VIEW',
          )) {
            if (widget.onView != null) {
              widget.onView?.call(widget.entities[index]);
            } else {
              context.goNamed(
                AppRoutesInformation.entityViewer.name,
                pathParameters: {
                  "resource": widget.entities[index].resourceName,
                  "id": entity['id'] ?? '',
                },
                extra: widget.entities[index],
              );
            }
            return;
          }

          context.showErrorSnackBar(
            message: context.translate(key: 'insufficient_permissions'),
          );
        },
      ),
    );
  }

  DataCell _editRecord(Map<String, dynamic> entity, int index) {
    return DataCell(
      TextButton.icon(
        label: Text(context.translate(key: 'edit_action')),
        icon: const Icon(Icons.edit_note_rounded),
        onPressed: () {
          if (AuthorizationHelper.hasMinimumPermission(
            context,
            widget.entities[index].resourceName,
            'UPDATE',
          )) {
            if (widget.onUpdate != null) {
              widget.onUpdate?.call(widget.entities[index]);
            }
            return;
          }

          context.showErrorSnackBar(
            message: context.translate(key: 'insufficient_permissions'),
          );
        },
      ),
    );
  }
  
  DataCell _deleteRecord(Map<String, dynamic> entity, int index) {
    return DataCell(
      TextButton.icon(
        label: Text(context.translate(key: 'delete_action')),
        icon:  Icon(Icons.delete_rounded, color: context.error,),
        onPressed: () {
          if (AuthorizationHelper.hasMinimumPermission(
            context,
            widget.entities[index].resourceName,
            'DELETE',
          )) {
            if (widget.onDelete != null) {
              widget.onDelete?.call(widget.entities[index]);
            }
            return;
          }

          context.showErrorSnackBar(
            message: context.translate(key: 'insufficient_permissions'),
          );
        },
      ),
    );
  }
}

class _EntityTableShimmer extends StatefulWidget {
  final int rowCount;
  final int columnCount;

  const _EntityTableShimmer({this.rowCount = 5, this.columnCount = 4});

  @override
  _EntityTableShimmerState createState() => _EntityTableShimmerState();
}

class _EntityTableShimmerState extends State<_EntityTableShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final ScrollController _scrollController = ScrollController();

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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Scrollbar(
          thumbVisibility: true,
          controller: _scrollController,
          child: Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: _boxDecoration(context),
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: DataTable(
                border: TableBorder.all(color: context.primary.withAlpha(30)),
                dividerThickness: 2,
                columns: _buildShimmerColumns(context),
                rows: _buildShimmerRows(context),
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _boxDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      color: context.surfaceContainer,
    );
  }

  List<DataColumn> _buildShimmerColumns(BuildContext context) {
    List<DataColumn> columns = [];

    for (int i = 0; i < widget.columnCount; i++) {
      columns.add(
        DataColumn(
          label: ShimmerContainer(
            width: 80 + (i * 20.0),
            height: 16,
            borderRadius: BorderRadius.circular(4),
            animationValue: _animation.value,
          ),
        ),
      );
    }

    // Add "show more" column
    columns.add(
      DataColumn(
        label: ShimmerContainer(
          width: 100,
          height: 16,
          borderRadius: BorderRadius.circular(4),
          animationValue: _animation.value,
        ),
      ),
    );

    return columns;
  }

  List<DataRow> _buildShimmerRows(BuildContext context) {
    return List.generate(widget.rowCount, (rowIndex) {
      return DataRow(cells: _buildShimmerCells(rowIndex));
    });
  }

  List<DataCell> _buildShimmerCells(int rowIndex) {
    List<DataCell> cells = [];

    for (int i = 0; i < widget.columnCount; i++) {
      cells.add(
        DataCell(
          ShimmerContainer(
            width: 60 + (i * 15.0) + (rowIndex * 5.0),
            height: 14,
            borderRadius: BorderRadius.circular(4),
            animationValue: _animation.value,
          ),
        ),
      );
    }

    // Add shimmer for "show more" button
    cells.add(
      DataCell(
        ShimmerContainer(
          width: 120,
          height: 32,
          borderRadius: BorderRadius.circular(16),
          animationValue: _animation.value,
        ),
      ),
    );

    return cells;
  }
}
