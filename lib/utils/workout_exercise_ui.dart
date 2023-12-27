import 'package:fitnessapp/models/models.dart';

import 'exercise_ui.dart';

class WorkoutExerciseUI {
  final ExerciseUI exerciseUI;
  final WorkoutExercise workoutExercise;

  const WorkoutExerciseUI(this.exerciseUI, this.workoutExercise);

  // copyWith
  WorkoutExerciseUI copyWith({
    ExerciseUI? exerciseUI,
    WorkoutExercise? workoutExercise,
  }) {
    return WorkoutExerciseUI(
      exerciseUI ?? this.exerciseUI.copyWith(),
      workoutExercise ?? this.workoutExercise.copyWith(),
    );
  }
}
