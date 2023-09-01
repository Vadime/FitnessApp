import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/workout_add_screen.dart';
import 'package:flutter/material.dart';

class UserWorkoutAddScreen extends StatelessWidget {
  final Workout? workout;
  const UserWorkoutAddScreen({this.workout, super.key});

  @override
  Widget build(BuildContext context) {
    return WorkoutAddScreen(
      upload: (newWorkout) async {
        await UserRepository.uploadUsersWorkout(newWorkout);
      },
      delete: () async {
        await UserRepository.deleteUserWorkout(workout!);
      },
      workout: workout,
    );
  }
}
