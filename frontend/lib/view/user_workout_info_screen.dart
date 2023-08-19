import 'dart:io';

import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/models/src/schedule.dart';
import 'package:fitnessapp/models/src/workout_exercise_type.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/view/exercise_image.dart';
import 'package:fitnessapp/view/home_screen.dart';
import 'package:fitnessapp/view/user_workout_add_screen.dart';
import 'package:fitnessapp/view/user_workout_in_progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

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
      child: ElevatedButtonWidget(
        'Start Workout',
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        widget.workout.name,
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
          TableWidget(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            rows: [
              TableRowWidget(
                cells: [
                  'Description',
                  widget.workout.description,
                ],
              ),
              TableRowWidget(
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
              child: FailWidget("Couldn't load exercises"),
            )
          else if (exercises!.isEmpty)
            const SizedBox(
              height: 100,
              child: LoadingWidget(),
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
          ListTileWidget(
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
          TableWidget(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            rows: [
              TableRowWidget(
                cells: [
                  'Description',
                  e.key.t1.description,
                ],
              ),
              if (e.key.t2.type is WorkoutExerciseTypeDuration) ...[
                TableRowWidget(
                  cells: [
                    'Minuten',
                    (e.key.t2.type as WorkoutExerciseTypeDuration)
                        .min
                        .toString()
                  ],
                ),
                TableRowWidget(
                  cells: [
                    'Sekunden',
                    (e.key.t2.type as WorkoutExerciseTypeDuration)
                        .sec
                        .toString()
                  ],
                ),
                TableRowWidget(
                  cells: [
                    'Weights',
                    (e.key.t2.type as WorkoutExerciseTypeDuration)
                        .weights
                        .toString()
                  ],
                ),
              ] else if (e.key.t2.type is WorkoutExerciseTypeRepetition) ...[
                TableRowWidget(
                  cells: [
                    'Sets',
                    (e.key.t2.type as WorkoutExerciseTypeRepetition)
                        .sets
                        .toString()
                  ],
                ),
                TableRowWidget(
                  cells: [
                    'Reps',
                    (e.key.t2.type as WorkoutExerciseTypeRepetition)
                        .reps
                        .toString()
                  ],
                ),
                TableRowWidget(
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
