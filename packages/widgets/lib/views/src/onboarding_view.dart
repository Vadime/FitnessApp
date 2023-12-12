import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class OnboardingView extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final Color? backgroundColor;
  final Color? imageBackgroundColor;
  final Gradient? backgroundGradient;
  final Color? foregroundColor;
  final double? padding;
  final double? radius;
  const OnboardingView({
    required this.title,
    required this.description,
    required this.image,
    this.imageBackgroundColor,
    this.backgroundColor,
    this.backgroundGradient,
    this.foregroundColor,
    this.padding,
    this.radius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: backgroundGradient,
        color: backgroundColor ??
            context.config.backgroundColor(context.brightness),
      ),
      padding:
          EdgeInsets.symmetric(horizontal: padding ?? context.config.padding),
      child: Column(
        children: [
          const Spacer(flex: 2),
          ImageWidget(AssetImage(image),
              width: context.mediaQuery.size.shortestSide / 2,
              height: context.mediaQuery.size.shortestSide / 2,
              backgroundColor: imageBackgroundColor,
              radius: context.mediaQuery.size.shortestSide / 4),
          const Spacer(),
          TextWidget(
            title,
            style:
                context.textTheme.titleLarge!.copyWith(color: foregroundColor),
          ),
          SizedBox(height: padding),
          TextWidget(
            description,
            style:
                context.textTheme.labelSmall!.copyWith(color: foregroundColor),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
