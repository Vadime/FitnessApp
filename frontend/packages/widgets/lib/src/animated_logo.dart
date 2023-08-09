library widgets;

import 'package:flutter/material.dart';

import 'logo.dart';

class AnimatedLogo extends StatefulWidget {
  final double size;
  // duration in milliseconds
  final int duration;
  const AnimatedLogo({this.size = 35, this.duration = 1000, super.key});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: Stream.periodic(
        const Duration(seconds: 1),
        (i) => i.isEven,
      ),
      builder: (context, snapshot) {
        bool d = snapshot.data ?? false;
        return Logo(
          size: d ? widget.size + 20 : widget.size - 20,
          duration: Duration(milliseconds: widget.duration),
          curve: Curves.easeInOut,
        );
      },
    );
  }
}
