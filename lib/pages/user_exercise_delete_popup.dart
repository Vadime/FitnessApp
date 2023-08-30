import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/pages/user_exercise_add_screen.dart';
import 'package:fitnessapp/pages/user_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserExerciseDeletePopup extends StatelessWidget {
  const UserExerciseDeletePopup({
    super.key,
    required this.widget,
  });

  final UserExerciseAddScreen widget;

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
          backgroundColor: context.config.errorColor,
          onPressed: () async {
            if (widget.exercise != null) {
              try {
                await ExerciseRepository.deleteExerciseImage(
                  widget.exercise!,
                );
                await UserRepository.deleteUsersExercise(widget.exercise!);
              } catch (e, s) {
                Logging.logDetails(e.toString(), s);
                Toast.info(
                  'Error deleting exercise: $e',
                  context: context,
                );
                Navigation.pop();
                return;
              }
            }
            Navigation.flush(
              widget: const UserHomeScreen(initialIndex: 2),
            );
          },
        ),
      ],
    );
  }
}
