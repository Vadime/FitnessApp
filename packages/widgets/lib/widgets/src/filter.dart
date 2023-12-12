import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class FilterWidget<T> extends StatefulWidget {
  final List<FilterObject<T>> rows;
  final List<String> filters;
  final Widget Function(List<FilterObject<T>> rows) widgetBuilder;
  const FilterWidget(this.rows, this.filters, this.widgetBuilder, {super.key});

  @override
  State<FilterWidget<T>> createState() => _FilterWidgetState<T>();
}

class _FilterWidgetState<T> extends State<FilterWidget<T>> {
  late List<FilterObject<T>> filteredRows;
  late TextFieldController searchCon;
  int filterIndex = 0;

  void showTableSettings() {
    Navigation.pushPopup(
        widget: ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 1.5),
      child: FilterSettingsWidget(
        columns: widget.filters,
        filterIndex: filterIndex,
        changeFilterIndex: (index) {
          filterIndex = index;
          setState(() {});
        },
      ),
    ));
  }

  @override
  void initState() {
    searchCon = TextFieldController('Suche')
      ..addListener(() {
        filteredRows = widget.rows
            .where((element) =>
                element.filter[filterIndex].toLowerCase().replaceAll(' ', '') ==
                searchCon.text.toLowerCase().replaceAll(' ', ''))
            .toList();
        setState(() {});
      });
    filteredRows = List.from(widget.rows);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    filteredRows = widget.rows
        .where((element) => element.filter[filterIndex]
            .toLowerCase()
            .replaceAll(' ', '')
            .contains(searchCon.text.toLowerCase().replaceAll(' ', '')))
        .toList();
    return ColumnWidget(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFieldWidget(controller: searchCon),
            ),
            const SizedBox(width: 20),
            IconButtonWidget(
              Icons.checklist_rounded,
              onPressed: () {
                showTableSettings();
              },
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        widget.widgetBuilder(filteredRows),
      ],
    );
  }
}
