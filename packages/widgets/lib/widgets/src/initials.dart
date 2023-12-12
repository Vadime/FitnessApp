import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class InitialsWidget extends StatelessWidget {
  final double size;
  final String initials;
  final Function()? onTap;
  final EdgeInsets margin;
  const InitialsWidget(
    this.initials, {
    this.size = 16,
    this.onTap,
    this.margin = EdgeInsets.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        margin: margin,
        decoration: BoxDecoration(
            color:
                context.theme.primaryColor.withOpacity(context.config.opacity),
            borderRadius: BorderRadius.circular(size / 2)),
        child: Center(
          child: TextWidget(initials,
              align: TextAlign.center,
              style: TextStyle(
                  fontSize: size / 3,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
