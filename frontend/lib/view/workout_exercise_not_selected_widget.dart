import 'dart:io';

import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/models/src/workout_exercise_type.dart';
import 'package:fitness_app/view/exercise_image.dart';
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
    return MyListTile(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
      title: entry.t1.name,
      leading: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: ExerciseImage(
          image: entry.t2,
        ),
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
