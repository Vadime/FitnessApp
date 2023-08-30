import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/pages/user_home_screen.dart';
import 'package:fitnessapp/pages/user_workout_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserWorkoutDeletePopup extends StatelessWidget {
  const UserWorkoutDeletePopup({
    super.key,
    required this.widget,
  });

  final UserWorkoutAddScreen widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Delete Workout',
          style: context.textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        const Text(
          'Are you sure you want to delete this workout?',
        ),
        const SizedBox(height: 20),
        ElevatedButtonWidget(
          'Delete',
          backgroundColor: context.colorScheme.error,
          onPressed: () async {
            if (widget.workout != null) {
              UserRepository.deleteUserWorkout(widget.workout!);
            }

            Navigation.flush(widget: const UserHomeScreen(initialIndex: 1));
          },
        ),
      ],
    );
  }
}
