import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  final IconData data;
  final double size;
  final Color? color;
  final EdgeInsets margin;

  const IconWidget(
    this.data, {
    this.size = 24,
    this.color,
    this.margin = EdgeInsets.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: margin,
        child: Icon(
          data,
          size: size,
          color: color,
        ),
      );
}
