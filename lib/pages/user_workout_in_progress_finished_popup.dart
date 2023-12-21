import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
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
          'Glückwunsch!',
          style: context.textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        const TextWidget(
          'Du hast das Workout erfolgreich abgeschlossen. Wie schwer war es für dich?',
        ),
        const SizedBox(height: 10),
        Row(
          children: WorkoutDifficulty.values
              .map(
                (e) => Expanded(
                  child: ElevatedButtonWidget(
                    e.str,
                    margin: const EdgeInsets.all(5),
                    onPressed: () async {
                      await UserRepository.saveWorkoutStatistics(
                        WorkoutStatistic(
                          uid: '',
                          workoutId: workout.uid,
                          dateTime: DateTime.now(),
                          difficulty: e,
                        ),
                      );
                      Navigation.flush(
                        widget: const HomeScreen(initialIndex: 4),
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
