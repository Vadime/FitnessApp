import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/models/src/workout_exercise_type.dart';
import 'package:fitnessapp/models_ui/workout_exercise_ui.dart';
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
              if (exercise.workoutExercise.type
                  is WorkoutExerciseTypeDuration) ...[
                TableRowWidget(
                  cells: [
                    'Minuten',
                    (exercise.workoutExercise.type
                            as WorkoutExerciseTypeDuration)
                        .min
                        .toString(),
                  ],
                ),
                TableRowWidget(
                  cells: [
                    'Sekunden',
                    (exercise.workoutExercise.type
                            as WorkoutExerciseTypeDuration)
                        .sec
                        .toString(),
                  ],
                ),
                TableRowWidget(
                  cells: [
                    'Weights',
                    (exercise.workoutExercise.type
                            as WorkoutExerciseTypeDuration)
                        .weights
                        .toString(),
                  ],
                ),
              ] else if (exercise.workoutExercise.type
                  is WorkoutExerciseTypeRepetition) ...[
                TableRowWidget(
                  cells: [
                    'Sets',
                    (exercise.workoutExercise.type
                            as WorkoutExerciseTypeRepetition)
                        .sets
                        .toString(),
                  ],
                ),
                TableRowWidget(
                  cells: [
                    'Reps',
                    (exercise.workoutExercise.type
                            as WorkoutExerciseTypeRepetition)
                        .reps
                        .toString(),
                  ],
                ),
                TableRowWidget(
                  cells: [
                    'Weights',
                    (exercise.workoutExercise.type
                            as WorkoutExerciseTypeRepetition)
                        .weights
                        .toString(),
                  ],
                ),
              ],
              TableRowWidget(
                cells: [
                  'Muscles',
                  exercise.exerciseUI.exercise.muscles
                      .map((e) => e.strName)
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
