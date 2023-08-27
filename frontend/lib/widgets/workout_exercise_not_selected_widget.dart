import 'dart:io';

import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/models/src/workout_exercise_type.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class WorkoutExerciseNotSelectedWidget extends StatelessWidget {
  final Tupel<Exercise, File?> entry;
  final List<Tripple<Exercise, WorkoutExercise, File?>> exercisesSel;
  final List<Tupel<Exercise, File?>> exercisesOth;
  final Function(Function()) setState;
  const WorkoutExerciseNotSelectedWidget({
    required this.entry,
    required this.exercisesSel,
    required this.exercisesOth,
    required this.setState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileWidget(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: const EdgeInsets.all(20),
      contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      title: entry.t1.name,
      leading: entry.t2 == null
          ? null
          : ImageWidget(
              FileImage(entry.t2!),
              height: 40,
              width: 40,
            ),
      subtitle: entry.t1.description,
      onTap: () {
        exercisesOth.removeWhere((e) => e.t1.uid == entry.t1.uid);
        exercisesSel.add(
          Tripple(
            entry.t1,
            WorkoutExercise(
              exerciseUID: entry.t1.uid,
              index: exercisesSel.length,
              type: WorkoutExerciseTypeRepetition(0, 0, 0),
            ),
            entry.t2,
          ),
        );
        setState(() {});
      },
    );
  }
}
