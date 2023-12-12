import 'package:flutter/material.dart';
import 'package:widgets/models/models.dart';

class BottomNavigationView {
  final String title;
  final Widget view;
  final IconData icon;
  final List<Widget>? actions;
  final Widget? primaryButton;
  const BottomNavigationView({
    required this.title,
    required this.view,
    required this.icon,
    this.primaryButton,
    this.actions,
  });

  NavigationBarItem get navigationBarItem =>
      NavigationBarItem(icon: icon, label: title);
}
