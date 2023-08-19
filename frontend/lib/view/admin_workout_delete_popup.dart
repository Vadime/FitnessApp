import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/view/admin_workout_add_screen.dart';
import 'package:fitnessapp/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AdminWorkoutDeletePopup extends StatelessWidget {
  const AdminWorkoutDeletePopup({
    super.key,
    required this.widget,
  });

  final AdminWorkoutAddScreen widget;

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
                await WorkoutRepository.deleteWorkout(widget.workout!);
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
