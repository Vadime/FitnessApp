import 'dart:io';

import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';

class ExerciseImage extends StatelessWidget {
  final double topPadding;
  const ExerciseImage({
    super.key,
    required this.imageFiles,
    required this.index,
    this.topPadding = 0,
  });

  final List<File?> imageFiles;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: topPadding),
      child: CircleAvatar(
        backgroundColor: context.theme.highlightColor,
        radius: 30,
        foregroundImage: imageFiles.elementAtOrNull(index) == null
            ? null
            : FileImage(imageFiles.elementAtOrNull(index)!),
      ),
    );
  }
}
