import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final Function()? onPressed;
  final EdgeInsets margin;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final MaterialTapTargetSize? tapTargetSize;
  final Size? minimumSize;
  final double? iconSize;
  const IconButtonWidget(
    this.icon, {
    required this.onPressed,
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.tapTargetSize,
    this.minimumSize,
    this.iconSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: margin,
        child: IconButton(
          iconSize: iconSize,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            tapTargetSize: tapTargetSize,
            minimumSize: minimumSize,
          ),
          color: foregroundColor,
          padding: padding,
          onPressed: () async {
            if (onPressed is Future Function()) {
              LoadingController().loadingProcess(onPressed);
            } else {
              onPressed?.call();
            }
          },
          icon: Icon(
            icon,
            size: iconSize,
          ),
        ),
      );
}
