import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ExerciseDeletePopup extends StatelessWidget {
  final Exercise? exercise;
  final Future Function() delete;
  const ExerciseDeletePopup({
    required this.exercise,
    required this.delete,
    super.key,
  });

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
            if (exercise != null) {
              try {
                await ExerciseRepository.deleteExerciseImage(exercise!);
                await delete();
              } catch (e) {
                ToastController().show(e);
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
