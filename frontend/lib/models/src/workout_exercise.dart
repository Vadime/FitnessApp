// wird nur in verbindung mit workout verwendet
import 'package:equatable/equatable.dart';

class WorkoutExercise extends Equatable {
  int index;
  final String exerciseUID;
  int recommendedSets;
  int recommendedReps;
  int weight;

  WorkoutExercise({
    required this.exerciseUID,
    required this.index,
    required this.recommendedSets,
    required this.recommendedReps,
    required this.weight,
  });

  // to json
  Map<String, dynamic> toJson() => {
        'exerciseUID': exerciseUID,
        'index': index,
        'recommendedSets': recommendedSets,
        'recommendedReps': recommendedReps,
        'weight': weight,
      };
  // from json
  factory WorkoutExercise.fromJson(Map<String, dynamic> json) =>
      WorkoutExercise(
        exerciseUID: json['exerciseUID'],
        index: json['index'] ?? -1,
        recommendedSets: json['recommendedSets'] ?? -1,
        recommendedReps: json['recommendedReps'] ?? -1,
        weight: json['weight'] ?? -1,
      );

  @override
  List<Object?> get props => [
        exerciseUID,
        index,
        recommendedSets,
        recommendedReps,
        weight,
      ];
}
