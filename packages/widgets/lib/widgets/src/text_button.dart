import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class TextButtonWidget extends StatelessWidget {
  final String text;
  final TextAlign? align;
  final Function()? onPressed;
  final EdgeInsets margin;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const TextButtonWidget(
    this.text, {
    required this.onPressed,
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
    this.align,
    this.foregroundColor,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: margin,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            padding: padding,
          ),
          onPressed: onPressed == null
              ? null
              : () async {
                  if (onPressed is Future Function()) {
                    LoadingController().loadingProcess(onPressed);
                  } else {
                    onPressed?.call();
                  }
                },
          child: TextWidget(
            text,
            align: align,
          ),
        ),
      );
}
