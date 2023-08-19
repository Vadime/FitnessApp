import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/utils/src/logging.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/view/admin_exercise_add_screen.dart';
import 'package:fitnessapp/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AdminExerciseDeletePopup extends StatelessWidget {
  const AdminExerciseDeletePopup({
    super.key,
    required this.widget,
  });

  final AdminExerciseAddScreen widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Delete Exercise',
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          const Text(
            'Are you sure you want to delete this exercise?',
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              if (widget.exercise != null) {
                try {
                  await ExerciseRepository.deleteExerciseImage(
                    widget.exercise!,
                  );
                  await ExerciseRepository.deleteExercise(widget.exercise!);
                } catch (e, s) {
                  Logging.error(e, s);
                  Navigation.pushMessage(
                    message: 'Error deleting exercise: $e',
                  );
                  Navigation.pop();
                  return;
                }
              }
              Navigation.flush(
                widget: const HomeScreen(initialIndex: 2),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
