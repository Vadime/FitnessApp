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
        'min': min,
        'sec': sec,
        'weights': weights,
      };

  WorkoutExerciseTypeDuration.fromJson(Map<String, dynamic> json)
      : min = json['min'].toString(),
        sec = json['sec'].toString(),
        weights = json['weights'].toString();
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
        'sets': sets,
        'reps': reps,
        'weights': weights,
      };

  WorkoutExerciseTypeRepetition.fromJson(Map<String, dynamic> json)
      : sets = json['sets'].toString(),
        reps = json['reps'].toString(),
        weights = json['weights'].toString();
}
