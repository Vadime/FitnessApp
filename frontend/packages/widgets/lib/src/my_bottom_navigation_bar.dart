import 'package:flutter/material.dart';

extension on BuildContext {
  double get bottomInset => MediaQuery.of(this).padding.bottom;
}

class MyBottomNavigationBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final Function(int)? onTap;
  const MyBottomNavigationBar({
    required this.items,
    this.currentIndex = 0,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 40,
        bottom: context.bottomInset,
        right: 40,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: MediaQuery(
          data: const MediaQueryData(
            padding: EdgeInsets.zero,
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            items: items,
          ),
        ),
      ),
    );
  }
}
