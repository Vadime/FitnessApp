import 'package:widgets/models/models.dart';


class DataTableRow<T> {
  final T member;
  final List<DataTableItem> items;
  const DataTableRow({required this.member, required this.items});
}
