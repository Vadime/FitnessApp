import 'package:widgets/widgets/widgets.dart';

abstract class WorkoutExerciseType {
  static const String name = 'WorkoutExerciseType';
  const WorkoutExerciseType();

  Map<String, dynamic> toJson();

  factory WorkoutExerciseType.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case WorkoutExerciseTypeDuration.name:
        return WorkoutExerciseTypeDuration.fromJson(json);
      case WorkoutExerciseTypeRepetition.name:
        return WorkoutExerciseTypeRepetition.fromJson(json);
      default:
        throw Exception('Unknown WorkoutExerciseType');
    }
  }
}

class WorkoutExerciseTypeDuration extends WorkoutExerciseType {
  static const String name = 'Duration';
  String min;
  String sec;
  String weights;
  WorkoutExerciseTypeDuration(
    this.min,
    this.sec,
    this.weights,
  );

  @override
  Map<String, dynamic> toJson() => {
        'type': name,
        'min': min.intFormat,
        'sec': sec.intFormat,
        'weights': weights.intFormat,
      };

  WorkoutExerciseTypeDuration.fromJson(Map<String, dynamic> json)
      : min = json['min'].toString().intFormat,
        sec = json['sec'].toString().intFormat,
        weights = json['weights'].toString().intFormat;
}

class WorkoutExerciseTypeRepetition extends WorkoutExerciseType {
  static const String name = 'Repetition';
  String sets;
  String reps;
  String weights;
  WorkoutExerciseTypeRepetition(
    this.sets,
    this.reps,
    this.weights,
  );

  @override
  Map<String, dynamic> toJson() => {
        'type': name,
        'sets': sets.intFormat,
        'reps': reps.intFormat,
        'weights': weights.intFormat,
      };

  WorkoutExerciseTypeRepetition.fromJson(Map<String, dynamic> json)
      : sets = json['sets'].toString().intFormat,
        reps = json['reps'].toString().intFormat,
        weights = json['weights'].toString().intFormat;
}
