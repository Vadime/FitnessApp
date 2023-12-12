
import 'package:widgets/models/models.dart';

class NavigationBarData {
  final List<NavigationBarItem> items;
  final int currentIndex;
  final void Function(int)? onChange;

  const NavigationBarData({
    required this.items,
    this.currentIndex = 0,
    this.onChange,
  });
}
