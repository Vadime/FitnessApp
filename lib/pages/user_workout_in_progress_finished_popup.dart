import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:fitnessapp/utils/workout_exercise_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserWorkoutInProgressFinishedPopup extends StatelessWidget {
  final Workout workout;
  final List<WorkoutExerciseUI> exercises;
  final DateTime startTime;
  final DateTime endTime;
  const UserWorkoutInProgressFinishedPopup({
    required this.startTime,
    required this.endTime,
    required this.workout,
    required this.exercises,
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
                          workout: workout,
                          exercises: exercises
                              .map((e) => e.exerciseUI.exercise)
                              .toList(),
                          difficulty: e,
                          startTime: startTime,
                          endTime: endTime,
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
