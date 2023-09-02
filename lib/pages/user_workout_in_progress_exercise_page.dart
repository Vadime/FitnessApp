import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/utils/workout_exercise_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserWorkoutInProgressExercisePage extends StatelessWidget {
  final WorkoutExerciseUI exercise;
  const UserWorkoutInProgressExercisePage({
    required this.exercise,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ImageWidget(
            exercise.exerciseUI.image == null
                ? null
                : MemoryImage(exercise.exerciseUI.image!),
            height: 200,
          ),
          const Expanded(child: SizedBox(height: 20)),
          // alle daten in tabelle anzeigen
          TableWidget(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            rows: [
              TableRowWidget(
                cells: ['Name', exercise.exerciseUI.exercise.name],
              ),
              TableRowWidget(
                cells: [
                  'Description',
                  exercise.exerciseUI.exercise.description,
                ],
              ),
              ...exercise.workoutExercise.type.values.entries
                  .map(
                    (e) => TableRowWidget(
                      cells: [
                        e.key,
                        e.value,
                      ],
                    ),
                  )
                  .toList(),
              TableRowWidget(
                cells: [
                  'Muscles',
                  exercise.exerciseUI.exercise.muscles
                      .map((e) => e.str)
                      .join(', '),
                ],
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
