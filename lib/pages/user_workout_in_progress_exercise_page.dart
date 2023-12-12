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
      child: OrientationBuilderWidget(
        portraitBuilder: smallExercise,
        landscapeBuilder: mediumExercise,
      ),
    );
  }

  Widget smallExercise(context) => Column(
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
                  'Beschreibung',
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
                  'Muskelgruppen',
                  exercise.exerciseUI.exercise.muscles
                      .map((e) => e.str)
                      .join(', '),
                ],
              ),
            ],
          ),
          const Spacer(),
        ],
      );

  Widget mediumExercise(context) => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ImageWidget(
              exercise.exerciseUI.image == null
                  ? null
                  : MemoryImage(exercise.exerciseUI.image!),
              height: 200,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: SingleChildScrollView(
              child: TableWidget(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                rows: [
                  TableRowWidget(
                    cells: [
                      'Name',
                      exercise.exerciseUI.exercise.name,
                    ],
                  ),
                  TableRowWidget(
                    cells: [
                      'Beschreibung',
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
                      'Muskelgruppen',
                      exercise.exerciseUI.exercise.muscles
                          .map((e) => e.str)
                          .join(', '),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
