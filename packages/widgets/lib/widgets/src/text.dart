import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;

  final EdgeInsets margin;
  final Function()? onTap;

  final Color? color;
  final double? size;
  final FontWeight? weight;
  final double? maxWidth;

  const TextWidget(
    this.data, {
    this.style,
    this.align,
    this.overflow,
    this.maxLines,
    this.margin = EdgeInsets.zero,
    this.size,
    this.onTap,
    this.color,
    this.weight,
    this.maxWidth,
    super.key,
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

  _build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: margin,
          child: Text(
            data,
            style: (style ?? const TextStyle()).copyWith(
              color: color,
              fontSize: size,
              fontWeight: weight,
            ),
            textAlign: align,
            overflow: overflow,
            maxLines: maxLines,
          ),
        ),
      );
}
