import 'dart:typed_data';

import 'package:fitnessapp/models/models.dart';

class ExerciseUI {
  final Exercise exercise;
  final Uint8List? image;

  const ExerciseUI(this.exercise, this.image);
}
