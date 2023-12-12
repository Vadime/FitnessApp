import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ScreenBuilderWidget extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints)
      smallBuilder;

  final Widget Function(BuildContext context, BoxConstraints constraints)
      mediumBuilder;

  final Widget Function(BuildContext context, BoxConstraints constraints)
      largeBuilder;

  const ScreenBuilderWidget(
      {required this.smallBuilder,
      required this.mediumBuilder,
      required this.largeBuilder,
      super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      switch (ThemeConfig.screenSize(context)) {
        case ScreenSize.small:
          return smallBuilder(context, constraints);
        case ScreenSize.medium:
          return mediumBuilder(context, constraints);
        case ScreenSize.large:
          return largeBuilder(context, constraints);
        default:
          return mediumBuilder(context, constraints);
      }
    });
  }
}
