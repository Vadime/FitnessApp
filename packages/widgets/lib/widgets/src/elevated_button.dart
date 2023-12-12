import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String text;
  final dynamic Function()? onPressed;
  final EdgeInsets margin;
  final Color? backgroundColor;
  final double? maxWidth;

  const ElevatedButtonWidget(
    this.text, {
    required this.onPressed,
    this.margin = EdgeInsets.zero,
    this.maxWidth,
    this.backgroundColor,
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
          child: Expanded(child: _build(context)),
        ),
      );
    }
  }

  _build(BuildContext context) => Padding(
        padding: margin,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              padding: EdgeInsets.all(context.config.paddingH)),
          onPressed: onPressed == null
              ? null
              : () async {
                  if (onPressed is Future Function()) {
                    LoadingController().loadingProcess(onPressed);
                  } else {
                    onPressed!.call();
                  }
                },
          child: TextWidget(text),
        ),
      );
}
