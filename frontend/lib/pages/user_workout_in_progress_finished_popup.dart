import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserWorkoutInProgressFinishedPopup extends StatelessWidget {
  final Workout workout;

  const UserWorkoutInProgressFinishedPopup({
    required this.workout,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextWidget(
          'Congratulations!',
          style: context.textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        const TextWidget(
          'You have finished your workout! How was it?',
        ),
        Row(
          children: WorkoutDifficulty.values
              .map(
                (e) => Expanded(
                  child: ElevatedButtonWidget(
                    e.strName,
                    margin: const EdgeInsets.all(10),
                    onPressed: () async {
                      await UserRepository.saveWorkoutStatistics(
                        workout,
                        e,
                      );
                      Navigation.flush(
                        widget: const HomeScreen(initialIndex: 3),
                      );
                    },
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
