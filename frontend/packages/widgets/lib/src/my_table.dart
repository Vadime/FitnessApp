import 'package:flutter/material.dart';

class MyTableRow {
  final List<String> cells;
  final EdgeInsets cellPadding;
  final Color? rowColor;
  const MyTableRow({
    required this.cells,
    this.cellPadding = const EdgeInsets.all(10),
    this.rowColor,
  });

  TableRow toTableRow({Color? rowColor}) {
    return TableRow(
      decoration: BoxDecoration(
        color: rowColor ?? this.rowColor,
      ),
      children: cells
          .map(
            (e) => Padding(
              padding: cellPadding,
              child: Text(e),
            ),
          )
          .toList(),
    );
  }
}

class MyTable extends StatelessWidget {
  final List<MyTableRow> rows;
  final Map<int, TableColumnWidth>? columnWidths;
  const MyTable({
    required this.rows,
    this.columnWidths,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Table(
        columnWidths: columnWidths,
        children: [
          for (int i = 0; i < rows.length; i++)
            if (i % 2 == 0)
              rows[i].toTableRow()
            else
              rows[i].toTableRow(
                rowColor:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
              )
        ],
      ),
    );
  }
}
