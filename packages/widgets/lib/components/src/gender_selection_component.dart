import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class GenderSelectionComponent extends StatelessWidget {
  final SegmentedButtonController<Gender> controller;
  final EdgeInsets margin;
  const GenderSelectionComponent({
    required this.controller,
    this.margin = EdgeInsets.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SlidingSegmentedButton(
        margin: margin,
        controller: controller,
        segments: const [
          ButtonData('Male', Gender.male),
          ButtonData('Female', Gender.female),
          ButtonData('Other', Gender.other),
        ],
      );
}
