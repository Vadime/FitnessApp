import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class LinearProgressWidget extends StatelessWidget {
  final double progress;

  /// The border radius of the progress indicator.
  final double? radius;

  /// The duration of the animation in milliseconds.
  final int duration;

  /// margin of the progress indicator.
  final EdgeInsets margin;

  final double? thickness;

  final Color? backgroundColor;
  final Color? foregroundColor;

  const LinearProgressWidget(
    this.progress, {
    this.radius,
    this.duration = 200,
    this.margin = EdgeInsets.zero,
    this.thickness,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: margin,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? context.config.radius),
          child: TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: duration),
            curve: Curves.easeInOut,
            tween: Tween<double>(
              begin: 0,
              end: progress,
            ),
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: thickness,
              color: foregroundColor ??
                  ((progress > 1.0)
                      ? Colors.red
                      : Theme.of(context).primaryColor),
              backgroundColor: backgroundColor ?? Colors.grey.withOpacity(0.3),
              borderRadius:
                  BorderRadius.circular(radius ?? context.config.radius),
            ),
          ),
        ),
      );
}
