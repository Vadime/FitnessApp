import 'package:flutter/material.dart';

class ColumnWidget extends StatelessWidget {
  final List<Widget>? children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final EdgeInsets margin;
  final double? maxWidth;

  const ColumnWidget({
    super.key,
    this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.margin = EdgeInsets.zero,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (maxWidth == null) {
      return _build(context);
    } else {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth!),
          child: _build(context),
        ),
      );
    }
  }

  _build(BuildContext context) => Padding(
        padding: margin,
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: children ?? [],
        ),
      );
}
