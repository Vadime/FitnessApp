import 'dart:io';

import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/models/src/schedule.dart';
import 'package:fitness_app/models/src/workout_exercise_type.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/exercise_image.dart';
import 'package:fitness_app/view/home_screen.dart';
import 'package:fitness_app/view/user_workout_add_screen.dart';
import 'package:fitness_app/view/user_workout_in_progress_screen.dart';
import 'package:fitness_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class UserWorkoutInfoScreen extends StatefulWidget {
  final Workout workout;
  final bool isAlreadyCopied;
  const UserWorkoutInfoScreen({
    required this.workout,
    this.isAlreadyCopied = false,
    super.key,
  });

  @override
  State<UserWorkoutInfoScreen> createState() => _UserWorkoutInfoScreenState();
}

class _UserWorkoutInfoScreenState extends State<UserWorkoutInfoScreen> {
  bool copied = false;
  Map<Tupel<Exercise, WorkoutExercise>, File?>? exercises;

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Widget editWorkoutButton() {
    return IconButton(
      onPressed: () async {
        Navigation.push(
          widget: UserWorkoutAddScreen(
            workout: widget.workout,
          ),
        );
      },
      icon: const Icon(Icons.edit_rounded),
    );
  }

  Widget copyWorkoutButton() {
    return IconButton(
      onPressed: () async {
        // copy workout to users workouts
        setState(() {
          copied = true;
        });
        await UserRepository.copyToPersonalWorkouts(widget.workout);

        Navigation.flush(widget: const HomeScreen(initialIndex: 1));
      },
      icon: !copied
          ? const Icon(Icons.copy_rounded)
          : const Icon(Icons.check_rounded, color: Colors.green),
    );
  }

  Widget startWorkoutButton() {
    return SafeArea(
      top: false,
      child: MyElevatedButton(
        margin: const EdgeInsets.fromLTRB(30, 0, 30, 10),
        onPressed: () {
          if (exercises == null) {
            return;
          }
          Navigation.push(
            widget: UserWorkoutInProgressScreen(
              workout: widget.workout,
              exercises: exercises!,
            ),
          );
        },
        text: 'Start Workout',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: MyAppBar(
        title: widget.workout.name,
        actions: [
          if (widget.isAlreadyCopied)
            editWorkoutButton()
          else
            copyWorkoutButton()
        ],
      ),
      bottomNavigationBar: startWorkoutButton(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SafeArea(
            bottom: false,
            child: SizedBox(),
          ),
          // workout description
          MyTable(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            rows: [
              MyTableRow(
                cells: [
                  'Description',
                  widget.workout.description,
                ],
              ),
              MyTableRow(
                cells: ['Schedule', widget.workout.schedule.strName],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Exercises'),
          const SizedBox(height: 10),

          // workout exercises
          if (exercises == null)
            const SizedBox(
              height: 100,
              child: MyErrorWidget(error: "Couldn't load exercises"),
            )
          else if (exercises!.isEmpty)
            const SizedBox(
              height: 100,
              child: MyLoadingWidget(),
            )
          else
            for (MapEntry<Tupel<Exercise, WorkoutExercise>, File?> e
                in exercises!.entries)
              exerciseListTile(e),
          const SafeArea(
            top: false,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }

  loadExercises() async {
    for (WorkoutExercise w in widget.workout.workoutExercises) {
      var exercise = await ExerciseRepository.getExercise(w.exerciseUID);
      var image = await ExerciseRepository.getExerciseImage(exercise);
      (exercises ??= {}).putIfAbsent(Tupel(exercise, w), () => image);
      setState(() {});
    }
  }

  Widget exerciseListTile(
    MapEntry<Tupel<Exercise, WorkoutExercise>, File?> e,
  ) =>
      Column(
        children: [
          const SizedBox(height: 10),
          MyListTile(
            padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
            title: e.key.t1.name,
            trailing: Padding(
              padding: const EdgeInsets.fromLTRB(
                0,
                10,
                0,
                10,
              ),
              child: ExerciseImage(
                image: e.value,
              ),
            ),
          ),
          const SizedBox(height: 10),
          MyTable(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            rows: [
              MyTableRow(
                cells: [
                  'Description',
                  e.key.t1.description,
                ],
              ),
              if (e.key.t2.type is WorkoutExerciseTypeDuration) ...[
                MyTableRow(
                  cells: [
                    'Minuten',
                    (e.key.t2.type as WorkoutExerciseTypeDuration)
                        .min
                        .toString()
                  ],
                ),
                MyTableRow(
                  cells: [
                    'Sekunden',
                    (e.key.t2.type as WorkoutExerciseTypeDuration)
                        .sec
                        .toString()
                  ],
                ),
                MyTableRow(
                  cells: [
                    'Weights',
                    (e.key.t2.type as WorkoutExerciseTypeDuration)
                        .weights
                        .toString()
                  ],
                ),
              ] else if (e.key.t2.type is WorkoutExerciseTypeRepetition) ...[
                MyTableRow(
                  cells: [
                    'Sets',
                    (e.key.t2.type as WorkoutExerciseTypeRepetition)
                        .sets
                        .toString()
                  ],
                ),
                MyTableRow(
                  cells: [
                    'Reps',
                    (e.key.t2.type as WorkoutExerciseTypeRepetition)
                        .reps
                        .toString()
                  ],
                ),
                MyTableRow(
                  cells: [
                    'Weights',
                    (e.key.t2.type as WorkoutExerciseTypeRepetition)
                        .weights
                        .toString()
                  ],
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
        ],
      );
}
