import 'dart:io';

import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/models/src/schedule.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/home_screen.dart';
import 'package:fitness_app/view/user_workout_delete_popup.dart';
import 'package:fitness_app/view/workout_exercise_not_selected_widget.dart';
import 'package:fitness_app/view/workout_exercise_selected_widget.dart';
import 'package:fitness_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class UserWorkoutAddScreen extends StatefulWidget {
  final Workout? workout;

  const UserWorkoutAddScreen({this.workout, super.key});

  @override
  State<UserWorkoutAddScreen> createState() => _UserWorkoutAddScreenState();
}

class _UserWorkoutAddScreenState extends State<UserWorkoutAddScreen> {
  late NameBloc nameBloc;
  late TextBloc descriptionBloc;

  List<Tripple<Exercise, WorkoutExercise, File?>> exercisesSel = [];
  List<Tupel<Exercise, File?>> exercisesOth = [];

  late Schedule selectedSchedule;

  @override
  void initState() {
    super.initState();
    nameBloc = NameBloc(
      initialValue: widget.workout?.name,
    );
    descriptionBloc = TextBloc(
      initialValue: widget.workout?.description,
      hint: 'Description',
    );
    selectedSchedule = widget.workout?.schedule != null
        ? widget.workout!.schedule
        : Schedule.daily;
    ExerciseRepository.getExercises().then(
      (exercises) async {
        var selectedExercises = (widget.workout?.workoutExercises
              ?..sort((a, b) => a.index.compareTo(b.index))) ??
            [];

        // Get exercises for workout
        for (int i = 0; i < exercises.length; i++) {
          Exercise exercise = exercises[i];
          var image = await ExerciseRepository.getExerciseImage(exercise);
          var workoutExercise = selectedExercises.firstWhere(
            (e) => e.exerciseUID == exercise.uid,
            orElse: () => WorkoutExercise.empty(),
          );
          if (workoutExercise.exerciseUID.isNotEmpty) {
            exercisesSel.add(
              Tripple(exercise, workoutExercise, image),
            );
          } else {
            exercisesOth.add(Tupel(exercise, image));
          }
          exercisesSel.sort((a, b) => a.b.index.compareTo(b.b.index));
          exercisesOth.sort((a, b) => a.t1.name.compareTo(b.t1.name));
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const MyAppBar(
        title: 'Add Workout',
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Row(
          children: [
            const SizedBox(width: 30),
            if (widget.workout != null) deleteButton(),
            addUpdateButton(),
            const SizedBox(width: 30),
          ],
        ),
      ),
      body: ListView(
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        children: [
          const SafeArea(
            bottom: false,
            child: SizedBox(),
          ),
          // name and description
          MyCard(
            padding: const EdgeInsets.all(20),
            children: [
              MyTextField(
                bloc: nameBloc,
              ),
              const SizedBox(height: 10),
              MyTextField(
                bloc: descriptionBloc,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Schedule',
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<Schedule>(
                emptySelectionAllowed: false,
                segments: [
                  for (var type in Schedule.values)
                    ButtonSegment(
                      label: Text(type.strName),
                      value: type,
                    ),
                ],
                selected: {selectedSchedule},
                onSelectionChanged: (p0) =>
                    setState(() => selectedSchedule = p0.first),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Exercises',
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),

          if (exercisesSel.isEmpty)
            SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  'No exercises this workout yet',
                  style: context.textTheme.labelSmall,
                ),
              ),
            ),
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: exercisesSel.length,
            onReorder: (oldIndex, newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              exercisesSel.elementAt(oldIndex).b.index = newIndex;
              exercisesSel.elementAt(newIndex).b.index = oldIndex;
              exercisesSel.sort((a, b) => a.b.index.compareTo(b.b.index));
              setState(() {});
            },
            itemBuilder: (context, index) => WorkoutExerciseSelectedWidget(
              key: Key(exercisesSel.elementAt(index).a.uid),
              entry: exercisesSel.elementAt(index),
              exercisesSel: exercisesSel,
              exercisesOth: exercisesOth,
              setState: setState,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Other exercises',
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          if (exercisesOth.isEmpty)
            SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  'No exercises left to add',
                  style: context.textTheme.labelSmall,
                ),
              ),
            ),
          for (var e in exercisesOth)
            WorkoutExerciseNotSelectedWidget(
              entry: e,
              exercisesSel: exercisesSel,
              exercisesOth: exercisesOth,
              setState: setState,
            ),
          const SafeArea(
            top: false,
            child: SizedBox(height: 0),
          ),
        ],
      ),
    );
  }

  Widget addUpdateButton() => Expanded(
        child: ElevatedButton(
          onPressed: () async {
            if (!nameBloc.isValid()) {
              return Navigation.pushMessage(
                message: nameBloc.state.errorText ?? 'Invalid name',
              );
            }
            if (!descriptionBloc.isValid()) {
              return Navigation.pushMessage(
                message:
                    descriptionBloc.state.errorText ?? 'Invalid description',
              );
            }
            try {
              exercisesSel.sort((a, b) => a.b.index.compareTo(b.b.index));

              Workout workout = Workout(
                uid: widget.workout?.uid ??
                    WorkoutRepository.collectionReference.doc().id,
                name: nameBloc.state.text ?? '-',
                description: descriptionBloc.state.text ?? '-',
                schedule: selectedSchedule,
                workoutExercises: exercisesSel.map((e) => e.b).toList(),
              );
              if (widget.workout != null) {
                UserRepository.updateUsersWorkout(workout);
              } else {
                UserRepository.addUsersWorkout(workout);
              }

              Navigation.flush(widget: const HomeScreen(initialIndex: 1));
            } catch (e) {
              Navigation.pushMessage(
                message: 'Error saving workout: $e',
              );
            }
          },
          child: Text(
            widget.workout != null ? 'Save Workout' : 'Add Workout',
          ),
        ),
      );

  Widget deleteButton() => Padding(
        padding: const EdgeInsets.only(right: 20),
        child: IconButton(
          onPressed: () => Navigation.pushPopup(
            widget: UserWorkoutDeletePopup(widget: widget),
          ),
          icon: const Icon(Icons.delete_rounded),
        ),
      );
}
