// wird nur in verbindung mit workout verwendet
import 'package:equatable/equatable.dart';

class WorkoutExercise extends Equatable {
  final String exerciceUID;
  final int recommendedSets;
  final int recommendedReps;
  const WorkoutExercise({
    required this.exerciceUID,
    required this.recommendedSets,
    required this.recommendedReps,
  });

  // to json
  Map<String, dynamic> toJson() => {
        'exerciceUID': exerciceUID,
        'recommendedSets': recommendedSets,
        'recommendedReps': recommendedReps,
      };
  // from json
  factory WorkoutExercise.fromJson(Map<String, dynamic> json) =>
      WorkoutExercise(
        exerciceUID: json['exerciceUID'],
        recommendedSets: json['recommendedSets'],
        recommendedReps: json['recommendedReps'],
      );

  @override
  List<Object?> get props => [
        exerciceUID,
        recommendedSets,
        recommendedReps,
      ];
}
