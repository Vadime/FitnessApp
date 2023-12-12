import 'package:flutter/material.dart';

class DismissData {
  final Key key;
  final void Function(DismissDirection)? onDismissed;
  final Widget? background;
  final Widget? secondaryBackground;
  final Map<DismissDirection, double> dismissThresholds;

  const DismissData({
    required this.key,
    required this.onDismissed,
    required this.background,
    this.secondaryBackground,
    this.dismissThresholds = const <DismissDirection, double>{},
  });
}
