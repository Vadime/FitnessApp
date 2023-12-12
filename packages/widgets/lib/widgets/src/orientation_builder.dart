import 'package:flutter/material.dart';

class OrientationBuilderWidget extends StatelessWidget {
  final Widget Function(BuildContext context) portraitBuilder;
  final Widget Function(BuildContext context) landscapeBuilder;
  final EdgeInsets margin;
  const OrientationBuilderWidget({
    required this.portraitBuilder,
    required this.landscapeBuilder,
    this.margin = EdgeInsets.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: OrientationBuilder(
        builder: (context, orientation) {
          switch (orientation) {
            case Orientation.portrait:
              return portraitBuilder(context);
            case Orientation.landscape:
              return landscapeBuilder(context);
            default:
              return portraitBuilder(context);
          }
        },
      ),
    );
  }
}
