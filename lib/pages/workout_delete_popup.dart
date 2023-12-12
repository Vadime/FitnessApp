import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class WorkoutDeletePopup extends StatelessWidget {
  const WorkoutDeletePopup({
    super.key,
    required this.workout,
    required this.delete,
  });

  final Workout workout;
  final Future Function() delete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextWidget(
          'Delete Workout',
          style: context.textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        const TextWidget(
          'Are you sure you want to delete this workout?',
        ),
        const SizedBox(height: 20),
        ElevatedButtonWidget(
          'Delete',
          backgroundColor: context.config.errorColor,
          onPressed: () async {
            await delete();
            Navigation.flush(widget: const HomeScreen(initialIndex: 1));
          },
        ),
      ],
    );
  }
}
