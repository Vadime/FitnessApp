import 'dart:typed_data';

import 'package:fitnessapp/models/models.dart';

class ExerciseUI {
  final Exercise exercise;
  final List<Uint8List>? images;

  const ExerciseUI(this.exercise, this.images);

  // copyWith
  ExerciseUI copyWith({
    Exercise? exercise,
    List<Uint8List>? images,
  }) {
    return ExerciseUI(
      exercise ?? this.exercise.copyWith(),
      images ?? List<Uint8List>.from(this.images ?? []),
    );
  }
}
