import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';


class ThemeSelectionComponent extends StatelessWidget {
  final ThemeController controller;
  final EdgeInsets margin;
  final double? maxWidth;
  const ThemeSelectionComponent({
    required this.controller,
    this.margin = EdgeInsets.zero,
    this.maxWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SlidingSegmentedButton(
        margin: margin,
        controller: controller,
        maxWidth: maxWidth,
        segments: const [
          ButtonData('System', ThemeMode.system),
          ButtonData('Light', ThemeMode.light),
          ButtonData('Dark', ThemeMode.dark),
        ],
      );
}
