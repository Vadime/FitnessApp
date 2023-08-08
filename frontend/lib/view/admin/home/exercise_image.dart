import 'dart:io';

import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';

class ExerciseImage extends StatelessWidget {
  const ExerciseImage({
    super.key,
    required this.imageFiles,
    required this.index,
  });

  final List<File?> imageFiles;
  final int index;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: context.theme.highlightColor,
      radius: 30,
      foregroundImage: imageFiles.elementAtOrNull(index) == null
          ? null
          : FileImage(imageFiles.elementAtOrNull(index)!),
    );
  }
}
