import 'package:equatable/equatable.dart';
import 'package:fitness_app/models/src/workout_exercise.dart';

class Workout extends Equatable {
  final String uid;
  final String name;
  final String description;
  final List<WorkoutExercise> workoutExercises;

  const Workout({
    required this.uid,
    required this.name,
    required this.description,
    required this.workoutExercises,
  });

  // to json
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'workoutExercises': workoutExercises.map((e) => e.toJson()).toList(),
      };

  // from json
  factory Workout.fromJson(String uid, Map<String, dynamic> json) => Workout(
        uid: uid,
        name: json['name'],
        description: json['description'],
        workoutExercises: (json['workoutExercises'] as List<dynamic>)
            .map((e) => WorkoutExercise.fromJson(e))
            .toList(),
      );

  @override
  List<Object?> get props => [
        uid,
        name,
        description,
        workoutExercises,
      ];
}
