import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class BlurWidget extends StatelessWidget {
  final Widget blurWidget;
  final bool blurred;
  final Widget visibleWidget;
  final double blurriness;
  const BlurWidget(
      {required this.visibleWidget,
      required this.blurWidget,
      required this.blurred,
      this.blurriness = 8,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        blurWidget,
        if (blurred)
          BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: blurriness,
              sigmaY: blurriness,
            ),
            child: Container(color: Colors.transparent, child: visibleWidget),
          )
      ],
    );
  }
}
