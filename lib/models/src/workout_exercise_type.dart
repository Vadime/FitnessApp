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

  WorkoutExerciseType copy() {
    switch (name) {
      case 'Duration':
        return WorkoutExerciseTypeDuration.fromJson(toJson());
      case 'Repetition':
        return WorkoutExerciseTypeRepetition.fromJson(toJson());
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
      'Sätze': sets,
      'Sekunden': sec,
      'Gewichte': weights,
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
      'Sätze': json['Sets'].toString(),
      'Sekunden': json['Seconds'].toString(),
      'Gewichte': json['Weights'].toString(),
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
      'Sätze': sets,
      'Wdh.': reps,
      'Gewichte': weights,
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
      'Sätze': json['Sets'].toString(),
      'Wdh.': json['Reps'].toString(),
      'Gewichte': json['Weights'].toString(),
    };
  }
}
