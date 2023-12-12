import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class DataTableWidget<T> extends StatefulWidget {
  final List<String> columns;
  final List<DataTableRow<T>> rows;
  final Widget? extraWidget;
  final bool scrollable;
  const DataTableWidget(this.columns, this.rows,
      {this.extraWidget, this.scrollable = true, Key? key})
      : super(key: key);

  @override
  State<DataTableWidget> createState() => DataTableWidgetState();
}

class DataTableWidgetState<T> extends State<DataTableWidget<T>> {
  int filterIndex = 0;
  List<bool> cellIsShown = [];
  late List<DataTableRow<T>> filteredRows;
  ScrollController tableHor = ScrollController();
  late TextFieldController searchCon;

  @override
  void initState() {
    super.initState();
    searchCon = TextFieldController('Suchbegriff')
      ..addListener(
        () {
          setState(() {
            filteredRows = List.from(widget.rows
                .where((row) => row.items[filterIndex].string
                    .replaceAll(' ', '')
                    .toLowerCase()
                    .contains(searchCon.text.toLowerCase().replaceAll(' ', '')))
                .toList());
          });
        },
      );
    filteredRows = List.from(widget.rows);
    cellIsShown = widget.columns.map((e) => true).toList();
  }

  void openTableSettings() {
    Navigation.pushPopup(
        widget: ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 1.5),
      child: TableSettingsWidget(
        columns: widget.columns,
        cellIsShown: cellIsShown,
        filterIndex: filterIndex,
        changeFilterIndex: (index) {
          filterIndex = index;
          setState(() {});
        },
        selectColumn: (select, index) {
          cellIsShown[index] = select;
          if (cellIsShown.where((element) => element).length - 1 == 0) {
            cellIsShown[index] = !select;
            return;
          }
          setState(() {});
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    filteredRows = List.from(widget.rows
        .where((row) => row.items[filterIndex].string
            .replaceAll(' ', '')
            .toLowerCase()
            .contains(searchCon.text.toLowerCase().replaceAll(' ', '')))
        .toList());

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
          child: Row(
            children: [
              Expanded(
                child: TextFieldWidget(controller: searchCon),
              ),
              const SizedBox(width: 20),
              IconButtonWidget(
                Icons.checklist_rounded,
                onPressed: () {
                  openTableSettings();
                },
              ),
              if (widget.extraWidget != null) widget.extraWidget!
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics:
                widget.scrollable ? null : const NeverScrollableScrollPhysics(),
            child: Scrollbar(
              thumbVisibility: false,
              controller: tableHor,
              interactive: true,
              trackVisibility: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(context.config.radius),
                  child: ScrollConfiguration(
                    behavior: MyCustomScrollBehavior(),
                    child: SingleChildScrollView(
                      controller: tableHor,
                      scrollDirection: Axis.horizontal,
                      child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(context.config.radius),
                          child: DataTable(
                            dividerThickness: 1,
                            horizontalMargin: 0,
                            checkboxHorizontalMargin: 0,
                            showBottomBorder: true,
                            headingRowColor: MaterialStatePropertyAll(
                                context.config.neutralColor),
                            columns: [
                              for (int columnIndex = 0;
                                  columnIndex < cellIsShown.length;
                                  columnIndex++)
                                if (cellIsShown[columnIndex])
                                  DataColumn(
                                    tooltip:
                                        widget.columns.elementAt(columnIndex),
                                    label: Expanded(
                                      child: Row(children: [
                                        TextWidget(
                                          widget.columns[columnIndex],
                                          margin: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                        ),
                                        if (columnIndex == filterIndex)
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.black),
                                            height: 10,
                                            width: 10,
                                          )
                                      ]),
                                    ),
                                  ),
                            ],
                            rows: List.generate(
                                filteredRows.length,
                                (rowIndex) => DataRow(
                                        cells: <Widget?>[
                                      ...List.generate(
                                          filteredRows[rowIndex].items.length,
                                          (index) => cellIsShown[index]
                                              ? filteredRows[rowIndex]
                                                  .items[index]
                                                  .child
                                              : null),
                                    ]
                                            .where((element) => element != null)
                                            .map((e) => DataCell(Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 0, 0, 0),
                                                child: e!)))
                                            .toList())),
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (filteredRows.isEmpty)
          const DescriptionWidget(
              Icons.no_accounts_outlined, 'Keine Mitglieder gefunden'),
      ],
    );
  }
}
