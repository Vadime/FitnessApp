import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/src/schedule.dart';
import 'package:fitnessapp/models/src/workout_exercise.dart';

class Workout {
  final String uid;
  final String name;
  final String description;
  final Schedule schedule;
  final List<WorkoutExercise> workoutExercises;

  Workout({
    required this.uid,
    required this.name,
    required this.description,
    required this.schedule,
    required this.workoutExercises,
  });

  // to json
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'schedule': schedule.index,
        'workoutExercises': workoutExercises.map((e) => e.toJson()).toList(),
      };

  // from json
  factory Workout.fromJson(String uid, Map<String, dynamic> json) {
    try {
      return Workout(
        uid: uid,
        name: json['name'],
        description: json['description'],
        schedule: Schedule.values[json['schedule']],
        workoutExercises: (json['workoutExercises'] as List<dynamic>)
            .map((e) => WorkoutExercise.fromJson(e))
            .toList(),
      );
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  // copy with
  Workout copyWith({
    String? uid,
    String? name,
    String? description,
    Schedule? schedule,
    List<WorkoutExercise>? workoutExercises,
    DateTime? startTime,
    DateTime? endTime,
  }) =>
      Workout(
        uid: uid ?? this.uid,
        name: name ?? this.name,
        description: description ?? this.description,
        schedule: schedule ?? this.schedule,
        workoutExercises: workoutExercises ??
            this.workoutExercises.map((e) => e.copyWith()).toList(),
      );

}
