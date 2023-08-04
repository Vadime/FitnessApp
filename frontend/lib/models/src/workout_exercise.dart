// wird nur in verbindung mit workout verwendet
import 'package:equatable/equatable.dart';

class WorkoutExercise extends Equatable {
  final String exerciseUID;
  int recommendedSets;
  int recommendedReps;
  WorkoutExercise({
    required this.exerciseUID,
    required this.recommendedSets,
    required this.recommendedReps,
  });

  // to json
  Map<String, dynamic> toJson() => {
        'exerciseUID': exerciseUID,
        'recommendedSets': recommendedSets,
        'recommendedReps': recommendedReps,
      };
  // from json
  factory WorkoutExercise.fromJson(Map<String, dynamic> json) =>
      WorkoutExercise(
        exerciseUID: json['exerciseUID'],
        recommendedSets: json['recommendedSets'],
        recommendedReps: json['recommendedReps'],
      );

  @override
  List<Object?> get props => [
        exerciseUID,
        recommendedSets,
        recommendedReps,
      ];
}
