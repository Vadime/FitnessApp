import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/utils/exercise_ui.dart';
import 'package:fitnessapp/utils/workout_exercise_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class WorkoutExerciseNotSelectedWidget extends StatelessWidget {
  final ExerciseUI entry;
  final List<WorkoutExerciseUI> exercisesSel;
  final List<ExerciseUI> exercisesOth;
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
      title: entry.exercise.name,
      leading: entry.image == null
          ? null
          : ImageWidget(
              MemoryImage(entry.image!),
              height: 40,
              width: 40,
            ),
      subtitle: entry.exercise.description,
      onTap: () {
        exercisesOth.removeWhere((e) => e.exercise.uid == entry.exercise.uid);
        exercisesSel.add(
          WorkoutExerciseUI(
            ExerciseUI(
              entry.exercise,
              entry.image,
            ),
            WorkoutExercise(
              exerciseUID: entry.exercise.uid,
              index: exercisesSel.length,
              type: WorkoutExerciseTypeRepetition('0', '0', '0'),
            ),
          ),
        );
        setState(() {});
      },
    );
  }
}
