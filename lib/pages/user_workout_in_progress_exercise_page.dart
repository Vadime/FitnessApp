import 'dart:io';

import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/models/src/workout_exercise_type.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserWorkoutInProgressExercisePage extends StatelessWidget {
  final MapEntry<Tupel<Exercise, WorkoutExercise>, File?> exercise;
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
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              exercise.value!,
              height: 200,
              fit: BoxFit.cover,
            ),
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
                cells: ['Name', exercise.key.t1.name],
              ),
              TableRowWidget(
                cells: ['Description', exercise.key.t1.description],
              ),
              TableRowWidget(
                cells: ['Type', exercise.key.t2.type.toString()],
              ),
              if (exercise.key.t2.type is WorkoutExerciseTypeDuration) ...[
                TableRowWidget(
                  cells: [
                    'Minuten',
                    (exercise.key.t2.type as WorkoutExerciseTypeDuration)
                        .min
                        .toString(),
                  ],
                ),
                TableRowWidget(
                  cells: [
                    'Sekunden',
                    (exercise.key.t2.type as WorkoutExerciseTypeDuration)
                        .sec
                        .toString(),
                  ],
                ),
                TableRowWidget(
                  cells: [
                    'Weights',
                    (exercise.key.t2.type as WorkoutExerciseTypeDuration)
                        .weights
                        .toString(),
                  ],
                ),
              ] else if (exercise.key.t2.type
                  is WorkoutExerciseTypeRepetition) ...[
                TableRowWidget(
                  cells: [
                    'Sets',
                    (exercise.key.t2.type as WorkoutExerciseTypeRepetition)
                        .sets
                        .toString(),
                  ],
                ),
                TableRowWidget(
                  cells: [
                    'Reps',
                    (exercise.key.t2.type as WorkoutExerciseTypeRepetition)
                        .reps
                        .toString(),
                  ],
                ),
                TableRowWidget(
                  cells: [
                    'Weights',
                    (exercise.key.t2.type as WorkoutExerciseTypeRepetition)
                        .weights
                        .toString(),
                  ],
                ),
              ],
              TableRowWidget(
                cells: [
                  'Muscles',
                  exercise.key.t1.muscles.map((e) => e.strName).join(', '),
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
