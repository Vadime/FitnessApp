library widgets;

import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class TableRowWidget {
  final List<String> cells;
  final EdgeInsets? cellPadding;
  final Color? rowColor;
  const TableRowWidget({
    required this.cells,
    this.cellPadding,
    this.rowColor,
  });

  TableRow toTableRow(BuildContext context, {Color? rowColor}) {
    return TableRow(
      decoration: BoxDecoration(
        color: rowColor ?? this.rowColor,
      ),
      children: cells
          .map(
            (e) => Padding(
              padding: cellPadding ?? EdgeInsets.all(context.config.paddingH),
              child: TextWidget(e),
            ),
          )
          .toList(),
    );
  }
}

class TableWidget extends StatelessWidget {
  final List<TableRowWidget> rows;
  final Map<int, TableColumnWidth>? columnWidths;
  final EdgeInsets margin;
  const TableWidget({
    required this.rows,
    this.columnWidths,
    this.margin = EdgeInsets.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget.single(
      margin: margin,
      child: Table(
        columnWidths: columnWidths,
        children: [
          for (int i = 0; i < rows.length; i++)
            if (i % 2 == 0)
              rows[i].toTableRow(context)
            else
              rows[i].toTableRow(
                context,
                rowColor:
                    context.theme.scaffoldBackgroundColor.withOpacity(0.5),
              )
        ],
      ),
    );
  }
}
