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
            workout: widget.workout.copyWith(),
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
            workout: widget.workout.copyWith(),
            exercises: exercises!.map((e) => e.copyWith()).toList(),
          ),
        );
      },
    );
  }

  String getCaloriesBurned(Workout workout) {
    if (exercises?.isEmpty ?? true) return '0 kcal';
    return '${exercises?.map((e) => e.exerciseUI.exercise.caloriesBurned).reduce((e1, e2) => e1 + e2).toStringAsFixed(0) ?? '0'} kcal';
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
              TableRowWidget(
                cells: [
                  'Kalorien',
                  getCaloriesBurned(widget.workout),
                ],
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
      CardWidget(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        children: [
          ListTileWidget(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            title: e.exerciseUI.exercise.name,
            subtitle: e.exerciseUI.exercise.description,
            subtitleMaxLines: 2,
            trailing: ImageWidget(
              e.exerciseUI.image == null
                  ? null
                  : MemoryImage(e.exerciseUI.image!),
              margin: const EdgeInsets.only(left: 10, right: 10),
              height: 50,
              width: 50,
            ),
          ),
          Row(
            children: [
              ...e.workoutExercise.type.values.entries
                  .map(
                    (e) => Flexible(
                      child: TextFieldWidget(
                        controller: TextFieldController(e.key, text: e.value),
                        enabled: false,
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ],
      );
}
