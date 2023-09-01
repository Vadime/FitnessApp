import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/workout_add_screen.dart';
import 'package:flutter/material.dart';

class AdminWorkoutAddScreen extends StatelessWidget {
  final Workout? workout;
  const AdminWorkoutAddScreen({this.workout, super.key});

  @override
  Widget build(BuildContext context) {
    return WorkoutAddScreen(
      upload: (newWorkout) async {
        await WorkoutRepository.saveWorkout(newWorkout);
      },
      delete: () async {
        await WorkoutRepository.deleteWorkout(workout!);
      },
      workout: workout,
    );
  }
}
