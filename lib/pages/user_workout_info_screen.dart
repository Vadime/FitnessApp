import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:fitnessapp/pages/user_workout_add_screen.dart';
import 'package:fitnessapp/pages/user_workout_in_progress_screen.dart';
import 'package:fitnessapp/utils/exercise_ui.dart';
import 'package:fitnessapp/utils/workout_exercise_ui.dart';
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

        Navigation.flush(widget: const HomeScreen(initialIndex: 0));
      },
    );
  }

  Widget startWorkoutButton() {
    return ElevatedButtonWidget(
      'Start Workout',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: widget.workout.name,
      actions: [
        if (widget.isAlreadyCopied)
          editWorkoutButton()
        else
          copyWorkoutButton(),
      ],
      primaryButton: startWorkoutButton(),
      body: ScrollViewWidget(
        maxInnerWidth: 600,
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
                  'Beschreibung',
                  widget.workout.description,
                ],
              ),
              TableRowWidget(
                cells: ['Zeitplan', widget.workout.schedule.str],
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextWidget(
            'Übungen',
            style: context.textTheme.bodyLarge,
          ),
          const SizedBox(height: 10),

          // workout exercises
          if (exercises == null)
            const SizedBox(
              height: 100,
              child: LoadingWidget(),
            )
          else if (exercises!.isEmpty)
            const SizedBox(
              height: 100,
              child: FailWidget('Keine Übungen vorhanden'),
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
      if (exercise != null) {
        exercises!.add(WorkoutExerciseUI(ExerciseUI(exercise, image), w));
      }
      setState(() {});
    }

    for (WorkoutExercise w in widget.workout.workoutExercises) {
      var exercise = await UserRepository.getUsersExercise(w.exerciseUID);
      var image = await ExerciseRepository.getExerciseImage(exercise);
      if (exercise != null) {
        exercises!.add(WorkoutExerciseUI(ExerciseUI(exercise, image), w));
      }
      setState(() {});
    }

    setState(() {});
  }

  Widget exerciseListTile(
    WorkoutExerciseUI e,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // ListTileWidget(
          //   padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          //   title: e.exerciseUI.exercise.name,
          // ),
          TextWidget(
            e.exerciseUI.exercise.name,
            style: context.textTheme.bodyLarge,
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
                      'Beschreibung',
                      e.exerciseUI.exercise.description,
                    ],
                  ),
                  ...e.workoutExercise.type.values.entries
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
