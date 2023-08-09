import 'package:flutter/material.dart';

class HomeItem {
  final String title;
  final IconData icon;
  final Widget page;
  final List<Widget>? actions;

  const HomeItem({
    required this.title,
    required this.icon,
    required this.page,
    this.actions,
  });

  BottomNavigationBarItem get bottomNavigationBarItem =>
      BottomNavigationBarItem(
        icon: Icon(icon),
        label: title,
      );
}
