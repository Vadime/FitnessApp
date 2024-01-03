import 'package:fitnessapp/pages/exercise_type_change_popup.dart';
import 'package:fitnessapp/utils/exercise_ui.dart';
import 'package:fitnessapp/utils/workout_exercise_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class WorkoutExerciseSelectedWidget extends StatelessWidget {
  final WorkoutExerciseUI entry;
  final List<WorkoutExerciseUI> exercisesSel;
  final List<ExerciseUI> exercisesOth;
  final Function(Function()) parentState;
  const WorkoutExerciseSelectedWidget({
    required this.entry,
    required this.exercisesSel,
    required this.exercisesOth,
    required this.parentState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      children: [
        ListTileWidget(
          title: entry.exerciseUI.exercise.name,
          trailing: ImageWidget(
            entry.exerciseUI.images == null
                ? null
                : MemoryImage(entry.exerciseUI.images!.first),
            margin: const EdgeInsets.only(left: 10),
            height: 50,
            width: 50,
          ),
          subtitle: entry.exerciseUI.exercise.description,
          subtitleMaxLines: 2,
        ),
        Row(
          children: [
            ...entry.workoutExercise.type.values.entries
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
                    type: entry.workoutExercise.type,
                    parentState: parentState,
                    onTypeChanged: (type) {
                      entry.workoutExercise.type = type;
                      parentState(() {});
                    },
                  ),
                );
              },
            ),
            IconButtonWidget(
              Icons.delete_rounded,
              foregroundColor: context.config.errorColor,
              onPressed: () {
                exercisesSel.removeWhere(
                  (e) =>
                      e.exerciseUI.exercise.uid ==
                      entry.exerciseUI.exercise.uid,
                );
                exercisesOth.add(
                  ExerciseUI(
                    entry.exerciseUI.exercise,
                    entry.exerciseUI.images,
                  ),
                );
                parentState(() {});
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }
}
