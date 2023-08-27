import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/pages/admin_exercise_add_screen.dart';
import 'package:fitnessapp/pages/home_screen.dart';
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
    return Column(
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
        ElevatedButtonWidget(
          'Delete',
          backgroundColor: context.colorScheme.error,
          onPressed: () async {
            if (widget.exercise != null) {
              try {
                await ExerciseRepository.deleteExerciseImage(
                  widget.exercise!,
                );
                await ExerciseRepository.deleteExercise(widget.exercise!);
              } catch (e, s) {
                Logging.logDetails(e.toString(), s);
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
        ),
      ],
    );
  }
}
