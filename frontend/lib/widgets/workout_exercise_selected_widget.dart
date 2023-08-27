import 'dart:io';

import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/models/src/workout_exercise_type.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class WorkoutExerciseSelectedWidget extends StatefulWidget {
  final Tripple<Exercise, WorkoutExercise, File?> entry;
  final List<Tripple<Exercise, WorkoutExercise, File?>> exercisesSel;
  final List<Tupel<Exercise, File?>> exercisesOth;
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
  late TextFieldController durMintesController;
  late TextFieldController durSecController;
  late TextFieldController durWeightController;
  late TextFieldController repSetsController;
  late TextFieldController repRepsController;
  late TextFieldController repWeightController;
  @override
  void initState() {
    super.initState();
    initControllers();
  }

  void initControllers() {
    if (widget.entry.b.type is WorkoutExerciseTypeDuration) {
      durMintesController = TextFieldController(
        'Minutes',
        text:
            (widget.entry.b.type as WorkoutExerciseTypeDuration).min.toString(),
      )..addListener(() {
          (widget.entry.b.type as WorkoutExerciseTypeDuration).min =
              int.tryParse(
                    durMintesController.text,
                  ) ??
                  0;
        });
      durSecController = TextFieldController(
        'Seconds',
        text:
            (widget.entry.b.type as WorkoutExerciseTypeDuration).sec.toString(),
      )..addListener(() {
          (widget.entry.b.type as WorkoutExerciseTypeDuration).sec =
              int.tryParse(
                    durSecController.text,
                  ) ??
                  0;
        });
      durWeightController = TextFieldController(
        'Weights',
        text: (widget.entry.b.type as WorkoutExerciseTypeDuration)
            .weights
            .toString(),
      )..addListener(() {
          (widget.entry.b.type as WorkoutExerciseTypeDuration).weights =
              int.tryParse(
                    durWeightController.text,
                  ) ??
                  0;
        });
    }
    if (widget.entry.b.type is WorkoutExerciseTypeRepetition) {
      repSetsController = TextFieldController(
        'Sets',
        text: (widget.entry.b.type as WorkoutExerciseTypeRepetition)
            .sets
            .toString(),
      )..addListener(() {
          (widget.entry.b.type as WorkoutExerciseTypeRepetition).sets =
              int.tryParse(
                    repSetsController.text,
                  ) ??
                  0;
        });
      repRepsController = TextFieldController(
        'Reps',
        text: (widget.entry.b.type as WorkoutExerciseTypeRepetition)
            .reps
            .toString(),
      )..addListener(() {
          (widget.entry.b.type as WorkoutExerciseTypeRepetition).reps =
              int.tryParse(
                    repRepsController.text,
                  ) ??
                  0;
        });
      repWeightController = TextFieldController(
        'Weights',
        text: (widget.entry.b.type as WorkoutExerciseTypeRepetition)
            .weights
            .toString(),
      )..addListener(() {
          (widget.entry.b.type as WorkoutExerciseTypeRepetition).weights =
              int.tryParse(
                    repWeightController.text,
                  ) ??
                  0;
        });
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
              '${widget.entry.b.type is WorkoutExerciseTypeDuration ? 'Duration' : 'Repetition'} Exercise - ',
              style: context.textTheme.labelMedium,
            ),
            TextButtonWidget(
              'Change',
              onPressed: () {
                // change exercise type
                if (widget.entry.b.type is WorkoutExerciseTypeDuration) {
                  widget.entry.b.type = WorkoutExerciseTypeRepetition(
                    0,
                    0,
                    (widget.entry.b.type as WorkoutExerciseTypeDuration)
                        .weights,
                  );
                } else if (widget.entry.b.type
                    is WorkoutExerciseTypeRepetition) {
                  widget.entry.b.type = WorkoutExerciseTypeDuration(
                    0,
                    0,
                    (widget.entry.b.type as WorkoutExerciseTypeRepetition)
                        .weights,
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
          title: widget.entry.a.name,
          leading: widget.entry.c == null
              ? null
              : ImageWidget(
                  FileImage(widget.entry.c!),
                  height: 40,
                  width: 40,
                ),
          subtitle: widget.entry.a.description,
          trailing: IconButtonWidget(
            Icons.delete_rounded,
            foregroundColor: context.colorScheme.error,
            onPressed: () {
              widget.exercisesSel.removeWhere(
                (e) => e.a.uid == widget.entry.a.uid,
              );
              widget.exercisesOth.add(Tupel(widget.entry.a, widget.entry.c));
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            if (widget.entry.b.type is WorkoutExerciseTypeDuration) ...[
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
            ] else if (widget.entry.b.type
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
