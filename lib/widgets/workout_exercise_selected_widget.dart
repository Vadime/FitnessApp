import 'package:fitnessapp/models/src/workout_exercise_type.dart';
import 'package:fitnessapp/models_ui/exercise_ui.dart';
import 'package:fitnessapp/models_ui/workout_exercise_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class WorkoutExerciseSelectedWidget extends StatefulWidget {
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
  State<WorkoutExerciseSelectedWidget> createState() =>
      _WorkoutExerciseSelectedWidgetState();
}

class _WorkoutExerciseSelectedWidgetState
    extends State<WorkoutExerciseSelectedWidget> {
  List<TextFieldController> typeControllers = [];

  @override
  void initState() {
    super.initState();
    initControllers();
  }

  void initControllers() {
    typeControllers.clear();

    for (var e in widget.entry.workoutExercise.type.values.entries) {
      TextFieldController controller = TextFieldController.number(
        labelText: e.key,
        text: e.value,
      )..selectionToEnd();

      controller.addListener(() {
        widget.entry.workoutExercise.type.values[e.key] =
            controller.text.intFormat;
      });

      typeControllers.add(controller);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextWidget(
              '${widget.entry.workoutExercise.type.name} Exercise -',
              style: context.textTheme.labelMedium,
            ),
            TextButtonWidget(
              'Change',
              onPressed: () {
                // change exercise type
                if (widget.entry.workoutExercise.type
                    is WorkoutExerciseTypeDuration) {
                  widget.entry.workoutExercise.type =
                      WorkoutExerciseTypeRepetition.empty();
                } else if (widget.entry.workoutExercise.type
                    is WorkoutExerciseTypeRepetition) {
                  widget.entry.workoutExercise.type =
                      WorkoutExerciseTypeDuration.empty();
                }
                initControllers();
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        ListTileWidget(
          padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          title: widget.entry.exerciseUI.exercise.name,
          leading: ImageWidget(
            widget.entry.exerciseUI.image == null
                ? null
                : MemoryImage(widget.entry.exerciseUI.image!),
            height: 40,
            width: 40,
          ),
          subtitle: widget.entry.exerciseUI.exercise.description,
          trailing: IconButtonWidget(
            Icons.delete_rounded,
            foregroundColor: context.config.errorColor,
            onPressed: () {
              widget.exercisesSel.removeWhere(
                (e) =>
                    e.exerciseUI.exercise.uid ==
                    widget.entry.exerciseUI.exercise.uid,
              );
              widget.exercisesOth.add(
                ExerciseUI(
                  widget.entry.exerciseUI.exercise,
                  widget.entry.exerciseUI.image,
                ),
              );
              widget.parentState(() {});
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (int i = 0; i < typeControllers.length; i++) ...[
              Expanded(
                child: TextFieldWidget(
                  controller: typeControllers[i],
                ),
              ),
              if (i < typeControllers.length - 1) const SizedBox(width: 10),
            ],
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
