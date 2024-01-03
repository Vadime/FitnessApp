import 'dart:typed_data';

import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/exercise_add_screen.dart';
import 'package:flutter/material.dart';

class AdminExerciseAddScreen extends StatelessWidget {
  final Exercise? exercise;
  final List<Uint8List>? imageFiles;
  const AdminExerciseAddScreen({
    this.exercise,
    this.imageFiles,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExerciseAddScreen(
      exercise: exercise,
      imageFiles: imageFiles,
      upload: (newExercise) async {
        await ExerciseRepository.uploadExercise(newExercise);
      },
      delete: () async {
        await ExerciseRepository.deleteExercise(exercise!);
      },
    );
  }
}
