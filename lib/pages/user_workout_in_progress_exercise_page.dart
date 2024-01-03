import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/exercise_type_change_popup.dart';
import 'package:fitnessapp/utils/workout_exercise_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserWorkoutInProgressExercisePage extends StatefulWidget {
  final WorkoutExerciseUI exercise;
  const UserWorkoutInProgressExercisePage({
    required this.exercise,
    super.key,
  });

  @override
  State<UserWorkoutInProgressExercisePage> createState() =>
      _UserWorkoutInProgressExercisePageState();
}

class _UserWorkoutInProgressExercisePageState
    extends State<UserWorkoutInProgressExercisePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: smallExercise(context),
    );
  }

  Widget smallExercise(context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                ImagesWidget(
                  widget.exercise.exerciseUI.images
                      ?.map((e) => MemoryImage(e))
                      .toList(),
                  height: 200,
                  width: 200,
                  margin: const EdgeInsets.all(10),
                ),
                // alle daten in tabelle anzeigen
                TableWidget(
                  margin: const EdgeInsets.all(10),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                  },
                  rows: [
                    TableRowWidget(
                      cells: ['Name', widget.exercise.exerciseUI.exercise.name],
                    ),
                    TableRowWidget(
                      cells: [
                        'Beschreibung',
                        widget.exercise.exerciseUI.exercise.description,
                      ],
                    ),
                    // ...exercise.workoutExercise.type.values.entries
                    //     .map(
                    //       (e) => TableRowWidget(
                    //         cells: [
                    //           e.key,
                    //           e.value,
                    //         ],
                    //       ),
                    //     )
                    //     .toList(),
                    TableRowWidget(
                      cells: [
                        'Muskelgruppen',
                        widget.exercise.exerciseUI.exercise.muscles
                            .map((e) => e.str)
                            .join(', '),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          CardWidget.single(
            margin: const EdgeInsets.all(10),
            child: Row(
              children: [
                ...widget.exercise.workoutExercise.type.values.entries
                    .map(
                      (e) => Flexible(
                        child: TextFieldWidget(
                          controller: TextFieldController(e.key, text: e.value),
                          enabled: false,
                        ),
                      ),
                    )
                    .toList(),
                IconButtonWidget(
                  Icons.edit_rounded,
                  onPressed: () {
                    Navigation.pushPopup(
                      widget: ExerciseTypeChangePopup(
                        type: widget.exercise.workoutExercise.type,
                        parentState: setState,
                        onTypeChanged: (type) {
                          widget.exercise.workoutExercise.type = type;
                          setState(() {});
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ],
      );
}
