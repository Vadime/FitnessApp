import 'dart:io';

import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/models/src/workout_exercise_type.dart';
import 'package:fitness_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

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
          MyTable(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            rows: [
              MyTableRow(
                cells: ['Name', exercise.key.t1.name],
              ),
              MyTableRow(
                cells: ['Description', exercise.key.t1.description],
              ),
              MyTableRow(
                cells: ['Type', exercise.key.t2.type.toString()],
              ),
              if (exercise.key.t2.type is WorkoutExerciseTypeDuration) ...[
                MyTableRow(
                  cells: [
                    'Minuten',
                    (exercise.key.t2.type as WorkoutExerciseTypeDuration)
                        .min
                        .toString()
                  ],
                ),
                MyTableRow(
                  cells: [
                    'Sekunden',
                    (exercise.key.t2.type as WorkoutExerciseTypeDuration)
                        .sec
                        .toString()
                  ],
                ),
                MyTableRow(
                  cells: [
                    'Weights',
                    (exercise.key.t2.type as WorkoutExerciseTypeDuration)
                        .weights
                        .toString()
                  ],
                ),
              ] else if (exercise.key.t2.type
                  is WorkoutExerciseTypeRepetition) ...[
                MyTableRow(
                  cells: [
                    'Sets',
                    (exercise.key.t2.type as WorkoutExerciseTypeRepetition)
                        .sets
                        .toString()
                  ],
                ),
                MyTableRow(
                  cells: [
                    'Reps',
                    (exercise.key.t2.type as WorkoutExerciseTypeRepetition)
                        .reps
                        .toString()
                  ],
                ),
                MyTableRow(
                  cells: [
                    'Weights',
                    (exercise.key.t2.type as WorkoutExerciseTypeRepetition)
                        .weights
                        .toString()
                  ],
                ),
              ],
              MyTableRow(
                cells: [
                  'Muscles',
                  exercise.key.t1.muscles.map((e) => e.strName).join(', ')
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
