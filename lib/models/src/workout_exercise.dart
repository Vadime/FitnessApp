// wird nur in verbindung mit workout verwendet

import 'package:fitnessapp/models/src/workout_exercise_type.dart';

class WorkoutExercise {
  int index;
  String exerciseUID;
  WorkoutExerciseType type;

  WorkoutExercise.empty({
    this.index = -1,
    this.exerciseUID = '',
  }) : type = WorkoutExerciseTypeRepetition('0', '0', '0');

  WorkoutExercise({
    required this.exerciseUID,
    required this.index,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'exerciseUID': exerciseUID,
        'index': index,
        'type': type.toJson(),
      };

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) =>
      WorkoutExercise(
        exerciseUID: json['exerciseUID'],
        index: json['index'] ?? -1,
        type: WorkoutExerciseType.fromJson(json['type']),
      );

  WorkoutExercise copyWith({
    String? exerciseUID,
    int? index,
    WorkoutExerciseType? type,
  }) {
    return WorkoutExercise(
      exerciseUID: exerciseUID ?? this.exerciseUID,
      index: index ?? this.index,
      type: type ?? this.type.copy(),
    );
  }
}
