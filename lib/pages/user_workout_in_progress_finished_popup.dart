import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/models/src/workout_statistic.dart';
import 'package:fitnessapp/pages/user_home_screen.dart';
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
        const SizedBox(height: 10),
        CardWidget.single(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: WorkoutDifficulty.values
                .map(
                  (e) => Expanded(
                    child: ElevatedButtonWidget(
                      e.strName,
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
                          widget: const UserHomeScreen(initialIndex: 3),
                        );
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
