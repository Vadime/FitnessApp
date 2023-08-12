import 'dart:io';

import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/models/src/workout_exercise_type.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/exercise_image.dart';
import 'package:fitness_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class WorkoutExerciseSelectedWidget extends StatelessWidget {
  final Tripple<Exercise, WorkoutExercise, File?> entry;
  final List<Tripple<Exercise, WorkoutExercise, File?>> exercisesSel;
  final List<Tupel<Exercise, File?>> exercisesOth;
  final Function(Function()) setState;
  const WorkoutExerciseSelectedWidget({
    required this.entry,
    required this.exercisesSel,
    required this.exercisesOth,
    required this.setState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        MyListTile(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          title: entry.a.name,
          leading: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ExerciseImage(
              image: entry.c,
            ),
          ),
          subtitle: entry.a.description,
          trailing: IconButton(
            icon: const Icon(
              Icons.delete_rounded,
              color: Colors.red,
            ),
            onPressed: () {
              exercisesSel.removeWhere(
                (e) => e.a.uid == entry.a.uid,
              );
              exercisesOth.add(Tupel(entry.a, entry.c));
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: context.theme.cardColor.withOpacity(0.5),
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              if (entry.b.type is WorkoutExerciseTypeDuration) ...[
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: (entry.b.type as WorkoutExerciseTypeDuration)
                          .min
                          .toString(),
                    ),
                    onChanged: (c) =>
                        (entry.b.type as WorkoutExerciseTypeDuration).min =
                            int.tryParse(
                                  c.toString(),
                                ) ??
                                0,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Minutes',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: (entry.b.type as WorkoutExerciseTypeDuration)
                          .sec
                          .toString(),
                    ),
                    onChanged: (c) =>
                        (entry.b.type as WorkoutExerciseTypeDuration).sec =
                            int.tryParse(
                                  c.toString(),
                                ) ??
                                0,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Seconds',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: (entry.b.type as WorkoutExerciseTypeDuration)
                          .weights
                          .toString(),
                    ),
                    onChanged: (c) =>
                        (entry.b.type as WorkoutExerciseTypeDuration).weights =
                            int.tryParse(
                                  c.toString(),
                                ) ??
                                0,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Weights',
                    ),
                  ),
                ),
              ] else if (entry.b.type is WorkoutExerciseTypeRepetition) ...[
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: (entry.b.type as WorkoutExerciseTypeRepetition)
                          .sets
                          .toString(),
                    ),
                    onChanged: (c) =>
                        (entry.b.type as WorkoutExerciseTypeRepetition).sets =
                            int.tryParse(
                                  c.toString(),
                                ) ??
                                0,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Sets',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: (entry.b.type as WorkoutExerciseTypeRepetition)
                          .reps
                          .toString(),
                    ),
                    onChanged: (c) =>
                        (entry.b.type as WorkoutExerciseTypeRepetition).reps =
                            int.tryParse(
                                  c.toString(),
                                ) ??
                                0,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Reps',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: (entry.b.type as WorkoutExerciseTypeRepetition)
                          .weights
                          .toString(),
                    ),
                    onChanged: (c) =>
                        (entry.b.type as WorkoutExerciseTypeRepetition).weights =
                            int.tryParse(
                                  c.toString(),
                                ) ??
                                0,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Weights',
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(
                  Icons.change_circle_rounded,
                ),
                onPressed: () {
                  // change exercise type
                  if (entry.b.type is WorkoutExerciseTypeDuration) {
                    entry.b.type = WorkoutExerciseTypeRepetition(
                      0,
                      0,
                      (entry.b.type as WorkoutExerciseTypeDuration).weights,
                    );
                  } else if (entry.b.type is WorkoutExerciseTypeRepetition) {
                    entry.b.type = WorkoutExerciseTypeDuration(
                      0,
                      0,
                      (entry.b.type as WorkoutExerciseTypeRepetition).weights,
                    );
                  }
                  setState(() {});
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
