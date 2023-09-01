abstract class WorkoutExerciseType {
  Map<String, String> values = {};
  String name = '';
  WorkoutExerciseType();

  Map<String, dynamic> toJson();

  factory WorkoutExerciseType.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'Duration':
        return WorkoutExerciseTypeDuration.fromJson(json);
      case 'Repetition':
        return WorkoutExerciseTypeRepetition.fromJson(json);
      default:
        throw Exception('Unknown WorkoutExerciseType');
    }
  }
}

class WorkoutExerciseTypeDuration extends WorkoutExerciseType {
  WorkoutExerciseTypeDuration(
    sets,
    sec,
    weights,
  ) {
    name = 'Duration';
    values = {
      'Sets': sets,
      'Seconds': sec,
      'Weights': weights,
    };
  }

  WorkoutExerciseTypeDuration.empty() : this('0', '0', '0');

  @override
  Map<String, dynamic> toJson() => {
        'type': name,
        ...values,
      };

  WorkoutExerciseTypeDuration.fromJson(Map<String, dynamic> json) {
    name = json['type'];
    values = {
      'Sets': json['Sets'].toString(),
      'Seconds': json['Seconds'].toString(),
      'Weights': json['Weights'].toString(),
    };
  }
}

class WorkoutExerciseTypeRepetition extends WorkoutExerciseType {
  WorkoutExerciseTypeRepetition(
    sets,
    reps,
    weights,
  ) {
    name = 'Repetition';
    values = {
      'Sets': sets,
      'Reps': reps,
      'Weights': weights,
    };
  }

  WorkoutExerciseTypeRepetition.empty() : this('0', '0', '0');

  @override
  Map<String, dynamic> toJson() => {
        'type': name,
        ...values,
      };

  WorkoutExerciseTypeRepetition.fromJson(Map<String, dynamic> json) {
    name = json['type'];
    values = {
      'Sets': json['Sets'].toString(),
      'Reps': json['Reps'].toString(),
      'Weights': json['Weights'].toString(),
    };
  }
}
