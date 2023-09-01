import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/models/src/schedule.dart';
import 'package:fitnessapp/models_ui/exercise_ui.dart';
import 'package:fitnessapp/models_ui/workout_exercise_ui.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:fitnessapp/pages/user_workout_add_screen.dart';
import 'package:fitnessapp/pages/user_workout_in_progress_screen.dart';
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
  List<WorkoutExerciseUI>? exercises;

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  Widget editWorkoutButton() {
    return IconButtonWidget(
      Icons.edit_rounded,
      onPressed: () async {
        Navigation.push(
          widget: UserWorkoutAddScreen(
            workout: widget.workout,
          ),
        );
      },
    );
  }

  Widget copyWorkoutButton() {
    return IconButtonWidget(
      !copied ? Icons.copy_rounded : Icons.check_rounded,
      onPressed: () async {
        // copy workout to users workouts
        setState(() {
          copied = true;
        });
        await UserRepository.copyToPersonalWorkouts(widget.workout);

        Navigation.flush(widget: const HomeScreen(initialIndex: 1));
      },
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
        action: (widget.isAlreadyCopied)
            ? editWorkoutButton()
            : copyWorkoutButton(),
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
                cells: ['Schedule', widget.workout.schedule.str],
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
            for (WorkoutExerciseUI e in exercises!) exerciseListTile(e),
          const SafeArea(
            top: false,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }

  loadExercises() async {
    exercises ??= [];
    for (WorkoutExercise w in widget.workout.workoutExercises) {
      var exercise = await ExerciseRepository.getExercise(w.exerciseUID);
      var image = await ExerciseRepository.getExerciseImage(exercise);
      exercises!.add(WorkoutExerciseUI(ExerciseUI(exercise, image), w));
      if (context.mounted) setState(() {});
    }
  }

  Widget exerciseListTile(
    WorkoutExerciseUI e,
  ) =>
      Column(
        children: [
          const SizedBox(height: 10),
          ListTileWidget(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            title: e.exerciseUI.exercise.name,
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              TableWidget(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                rows: [
                  TableRowWidget(
                    cells: [
                      'Description',
                      e.exerciseUI.exercise.description,
                    ],
                  ),
                  ...e.workoutExercise.type
                      .values
                      .entries
                      .map(
                        (e) => TableRowWidget(
                          cells: [
                            e.key,
                            e.value,
                          ],
                        ),
                      )
                      .toList(),
                ],
              ),
              Positioned(
                right: 20,
                bottom: 20,
                child: ImageWidget(
                  e.exerciseUI.image == null
                      ? null
                      : MemoryImage(e.exerciseUI.image!),
                  height: 50,
                  width: 50,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      );
}
