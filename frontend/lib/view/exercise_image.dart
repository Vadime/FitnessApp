import 'dart:io';

import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';

class ExerciseImage extends StatelessWidget {
  final double topPadding;
  final File? image;

  const ExerciseImage({
    super.key,
    this.image,
    this.topPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: topPadding),
      child: CircleAvatar(
        backgroundColor: context.theme.highlightColor,
        radius: 30,
        foregroundImage: image == null ? null : FileImage(image!),
      ),
    );
  }
}
