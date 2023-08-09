import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/home_screen.dart';
import 'package:fitness_app/view/user_workout_add_screen.dart';
import 'package:flutter/material.dart';

class UserWorkoutDeletePopup extends StatelessWidget {
  const UserWorkoutDeletePopup({
    super.key,
    required this.widget,
  });

  final UserWorkoutAddScreen widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              if (widget.workout != null) {
                UserRepository.deleteUserWorkout(widget.workout!);
              }

              Navigation.flush(widget: const HomeScreen(initialIndex: 1));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
