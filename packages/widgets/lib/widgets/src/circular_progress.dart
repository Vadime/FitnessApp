import 'package:flutter/material.dart';

class CircularProgressWidget extends StatelessWidget {
  final double progress;

  /// The border radius of the progress indicator.
  final double radius;

  /// The duration of the animation in milliseconds.
  final int duration;

  /// margin of the progress indicator.
  final EdgeInsets margin;

  /// The thickness of the line used to draw the circle.
  final double? thickness;

  /// The progress indicator's background color.
  final Color? backgroundColor;

  /// The progress indicator's foreground color.
  final Color? foregroundColor;

  /// The text to display in the center of the circle.
  final String? centerText;

  /// A widget to display in the center of the circle.
  /// If this is specified, the [centerText] will be ignored.
  final Widget? centerWidget;

  const CircularProgressWidget(
    this.progress, {
    this.radius = 20,
    this.duration = 200,
    this.margin = EdgeInsets.zero,
    this.thickness,
    this.backgroundColor,
    this.foregroundColor,
    this.centerText,
    this.centerWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: margin,
        child: SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: AspectRatio(
            aspectRatio: 1,
            child: TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: duration),
              curve: Curves.easeInOut,
              tween: Tween<double>(
                begin: 0,
                end: progress,
              ),
              builder: (context, value, _) => Stack(
                fit: StackFit.expand,
                children: [
                  if (centerWidget != null)
                    Center(
                      child: centerWidget,
                    )
                  else if (centerText != null)
                    Center(
                      child: Text(
                        centerText!,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                  CircularProgressIndicator(
                    value: value,
                    strokeWidth: thickness ?? 4,
                    color: foregroundColor ?? Theme.of(context).primaryColor,
                    backgroundColor: backgroundColor ?? Colors.grey.shade300,
                    strokeCap: StrokeCap.round,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
