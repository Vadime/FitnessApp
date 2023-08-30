import 'package:fitnessapp/models/src/workout_exercise_type.dart';
import 'package:fitnessapp/models_ui/exercise_ui.dart';
import 'package:fitnessapp/models_ui/workout_exercise_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class WorkoutExerciseSelectedWidget extends StatefulWidget {
  final WorkoutExerciseUI entry;
  final List<WorkoutExerciseUI> exercisesSel;
  final List<ExerciseUI> exercisesOth;
  const WorkoutExerciseSelectedWidget({
    required this.entry,
    required this.exercisesSel,
    required this.exercisesOth,
    super.key,
  });

  @override
  State<WorkoutExerciseSelectedWidget> createState() =>
      _WorkoutExerciseSelectedWidgetState();
}

class _WorkoutExerciseSelectedWidgetState
    extends State<WorkoutExerciseSelectedWidget> {
  TextFieldController? durMintesController;
  TextFieldController? durSecController;
  TextFieldController? durWeightController;
  TextFieldController? repSetsController;
  TextFieldController? repRepsController;
  TextFieldController? repWeightController;
  @override
  void initState() {
    super.initState();
    initControllers();
  }

  void initControllers() {
    if (widget.entry.workoutExercise.type is WorkoutExerciseTypeDuration) {
      durMintesController = TextFieldController.number(
        labelText: 'Minutes',
        text: (widget.entry.workoutExercise.type as WorkoutExerciseTypeDuration)
            .min
            .toString(),
      )
        ..addListener(() {
          (widget.entry.workoutExercise.type as WorkoutExerciseTypeDuration)
              .min = durMintesController?.text ?? '';
        })
        ..selectionToEnd();
      durSecController = TextFieldController.number(
        labelText: 'Seconds',
        text: (widget.entry.workoutExercise.type as WorkoutExerciseTypeDuration)
            .sec
            .toString(),
      )
        ..addListener(() {
          (widget.entry.workoutExercise.type as WorkoutExerciseTypeDuration)
              .sec = durSecController?.text ?? '';
        })
        ..selectionToEnd();
      durWeightController = TextFieldController.number(
        labelText: 'Weights',
        text: (widget.entry.workoutExercise.type as WorkoutExerciseTypeDuration)
            .weights
            .toString(),
      )
        ..addListener(() {
          (widget.entry.workoutExercise.type as WorkoutExerciseTypeDuration)
              .weights = durWeightController?.text ?? '';
        })
        ..selectionToEnd();
    }
    if (widget.entry.workoutExercise.type is WorkoutExerciseTypeRepetition) {
      repSetsController = TextFieldController.number(
        labelText: 'Sets',
        text:
            (widget.entry.workoutExercise.type as WorkoutExerciseTypeRepetition)
                .sets
                .toString(),
      )
        ..addListener(() {
          (widget.entry.workoutExercise.type as WorkoutExerciseTypeRepetition)
              .sets = repSetsController?.text ?? '';
        })
        ..selectionToEnd();
      repRepsController = TextFieldController.number(
        labelText: 'Reps',
        text:
            (widget.entry.workoutExercise.type as WorkoutExerciseTypeRepetition)
                .reps
                .toString(),
      )
        ..addListener(() {
          (widget.entry.workoutExercise.type as WorkoutExerciseTypeRepetition)
              .reps = repRepsController?.text ?? '';
        })
        ..selectionToEnd();
      repWeightController = TextFieldController.number(
        labelText: 'Weights',
        text:
            (widget.entry.workoutExercise.type as WorkoutExerciseTypeRepetition)
                .weights
                .toString(),
      )
        ..addListener(() {
          (widget.entry.workoutExercise.type as WorkoutExerciseTypeRepetition)
              .weights = repWeightController?.text ?? '';
        })
        ..selectionToEnd();
    }
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
              '${widget.entry.workoutExercise.type is WorkoutExerciseTypeDuration ? 'Duration' : 'Repetition'} Exercise - ',
              style: context.textTheme.labelMedium,
            ),
            TextButtonWidget(
              'Change',
              onPressed: () {
                // change exercise type
                if (widget.entry.workoutExercise.type
                    is WorkoutExerciseTypeDuration) {
                  widget.entry.workoutExercise.type =
                      WorkoutExerciseTypeRepetition(
                    '0',
                    '0',
                    '0',
                  );
                } else if (widget.entry.workoutExercise.type
                    is WorkoutExerciseTypeRepetition) {
                  widget.entry.workoutExercise.type =
                      WorkoutExerciseTypeDuration(
                    '0',
                    '0',
                    '0',
                  );
                }
                initControllers();
                setState(() {});
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
            foregroundColor: context.colorScheme.error,
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
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            if (widget.entry.workoutExercise.type
                is WorkoutExerciseTypeDuration) ...[
              Expanded(
                child: TextFieldWidget(controller: durMintesController),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFieldWidget(controller: durSecController),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFieldWidget(controller: durWeightController),
              ),
            ] else if (widget.entry.workoutExercise.type
                is WorkoutExerciseTypeRepetition) ...[
              Expanded(
                child: TextFieldWidget(controller: repSetsController),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFieldWidget(controller: repRepsController),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFieldWidget(controller: repWeightController),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
