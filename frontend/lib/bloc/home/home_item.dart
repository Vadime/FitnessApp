import 'package:flutter/material.dart';

class HomeItem {
  final String title;
  final IconData icon;
  final Widget page;
  final Widget? action;

  const HomeItem({
    required this.title,
    required this.icon,
    required this.page,
    this.action,
  });

  BottomNavigationBarItem get bottomNavigationBarItem =>
      BottomNavigationBarItem(
        icon: Icon(icon),
        label: title,
      );
}
