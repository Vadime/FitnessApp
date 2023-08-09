library widgets;

import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double size;
  final Duration duration;
  final Curve curve;
  const Logo({
    this.size = 28,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeInOut,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: size,
      height: size,
      curve: curve,
      duration: duration,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'res/logo/foreground.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
