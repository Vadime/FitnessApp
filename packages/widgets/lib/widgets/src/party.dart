library widgets;

import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class PartyParticle {
  /// Draw a star shape.
  static Path star(Size size) {
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = _degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = _degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(
        halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step),
      );
      path.lineTo(
        halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep),
      );
    }
    path.close();
    return path;
  }

  /// Convert degrees to radians.
  static double _degToRad(double deg) => deg * (pi / 180.0);
}

class PartyWidget extends StatelessWidget {
  final PartyController controller;
  final bool enableLoop;
  const PartyWidget({
    required this.controller,
    this.enableLoop = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: controller,
      blastDirectionality: BlastDirectionality.explosive,
      shouldLoop: enableLoop,
      colors: const [
        Colors.green,
        Colors.blue,
        Colors.pink,
        Colors.orange,
        Colors.purple
      ], // manually specify the colors to be used
      createParticlePath: PartyParticle.star, // define a custom shape/path.
    );
  }
}
