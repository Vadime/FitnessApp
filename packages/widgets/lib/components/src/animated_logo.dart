import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:widgets/widgets.dart';

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({super.key});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> rotateAanimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    rotateAanimation = Tween<double>(begin: 0.0, end: 1)
        .chain(CurveTween(curve: Curves.easeOutCubic))
        .animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => CustomRotationTransition(
        turns: rotateAanimation,
        child: ImageWidget(
          AssetImage(
            context.config.logoLocation,
          ),
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}

class CustomRotationTransition extends AnimatedWidget {
  const CustomRotationTransition({
    Key? key,
    required Animation<double> turns,
    required this.child,
  }) : super(key: key, listenable: turns);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Animation<double> turns = listenable as Animation<double>;
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(turns.value * 4.0 * pi),
      child: child,
    );
  }
}
