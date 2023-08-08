import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/models/src/schedule.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin/home/exercise_image.dart';
import 'package:fitness_app/view/both/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserWorkoutAddScreen extends StatefulWidget {
  final Workout? workout;

  const UserWorkoutAddScreen({this.workout, super.key});

  @override
  State<UserWorkoutAddScreen> createState() => _UserWorkoutAddScreenState();
}

class _UserWorkoutAddScreenState extends State<UserWorkoutAddScreen> {
  late NameBloc nameBloc;
  late TextBloc descriptionBloc;

  Map<String, File?> imageFiles = {};

  List<Exercise> exercisesSel = [];
  List<Exercise> exercisesOth = [];

  List<WorkoutExercise> selectedExercises = [];
  late Set<Schedule> selectedSchedule;

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
        ? {widget.workout!.schedule}
        : {Schedule.daily};
    ExerciseRepository.getExercises().then(
      (exercises) {
        selectedExercises = widget.workout?.workoutExercises ?? [];

        // Get exercises for workout
        for (int i = 0; i < exercises.length; i++) {
          Exercise exercise = exercises[i];
          if (selectedExercises
              .where((e) => e.exerciseUID == exercise.uid)
              .isNotEmpty) {
            exercisesSel.add(exercise);
          } else {
            exercisesOth.add(exercise);
          }
        }
        // sort selectedExercises and exerciseSel to be in same order
        selectedExercises.sort((a, b) => a.index.compareTo(b.index));
        exercisesSel.sort((a, b) {
          // Get index of exercise in selectedExercises
          int indexA =
              selectedExercises.indexWhere((e) => e.exerciseUID == a.uid);
          int indexB =
              selectedExercises.indexWhere((e) => e.exerciseUID == b.uid);
          return indexA.compareTo(indexB);
        });

        // Get images for exercises
        for (int i = 0; i < exercises.length; i++) {
          ExerciseRepository.getExerciseImage(exercises[i]).then(
            (value) => setState(
              () => imageFiles.putIfAbsent(exercises[i].uid, () => value),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Add Workout'),
        actions: [
          if (widget.workout != null) deleteButton(),
          addUpdateButton(),
        ],
      ),
      body: ListView(
        physics: const ScrollPhysics(),
        children: [
          const SafeArea(
            bottom: false,
            child: SizedBox(),
          ),
          // name and description
          Card(
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
            ),
          ),
          // schedule
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              'Schedule',
              style: context.textTheme.bodyMedium,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: SegmentedButton<Schedule>(
                emptySelectionAllowed: false,
                segments: [
                  for (var type in Schedule.values)
                    ButtonSegment(
                      label: Text(type.strName),
                      value: type,
                    ),
                ],
                selected: selectedSchedule,
                onSelectionChanged: (p0) =>
                    setState(() => selectedSchedule = p0),
              ),
            ),
          ),
          // exercises in workout
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              'Exercises',
              style: context.textTheme.bodyMedium,
            ),
          ),
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
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final Exercise item = exercisesSel.removeAt(oldIndex);
                exercisesSel.insert(newIndex, item);

                final WorkoutExercise item2 =
                    selectedExercises.removeAt(oldIndex);
                selectedExercises.insert(newIndex, item2);

                selectedExercises.asMap().forEach((index, element) {
                  element.index = index;
                });
              });
            },
            itemBuilder: (context, index) {
              return selectedExerciseWidget(
                imageFiles[selectedExercises[index].exerciseUID],
                exercisesSel[index],
                selectedExercises[index],
              );
            },
          ),
          // exercises not in workout
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Text(
              'Other exercises',
              style: context.textTheme.bodyMedium,
            ),
          ),
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
          ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: exercisesOth.length,
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            itemBuilder: (context, index) {
              return otherExerciseWidget(
                imageFiles[exercisesOth[index].uid],
                exercisesOth[index],
              );
            },
          ),
        ],
      ),
    );
  }

  Card selectedExerciseWidget(
    File? image,
    Exercise exercise,
    WorkoutExercise? currentExercise,
  ) {
    return Card(
      key: Key(exercise.uid),
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(exercise.name),
            ),
            leading: ExerciseImage(
              imageFiles: [image],
              index: 0,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(exercise.description),
            ),
            trailing: const Icon(Icons.drag_handle),
            onTap: () {
              selectedExercises.removeWhere(
                (e) => e.exerciseUID == exercise.uid,
              );
              exercisesSel.removeWhere(
                (e) => e.uid == exercise.uid,
              );
              exercisesOth.add(exercise);
              setState(() {});
            },
            selected: true,
            selectedTileColor: context.theme.highlightColor,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                      text: currentExercise?.recommendedSets.toString(),
                    ),
                    onChanged: (c) =>
                        currentExercise?.recommendedSets = int.tryParse(
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
                      text: currentExercise?.recommendedReps.toString(),
                    ),
                    onChanged: (c) =>
                        currentExercise?.recommendedReps = int.tryParse(
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
                      text: currentExercise?.weight.toString(),
                    ),
                    onChanged: (c) => currentExercise?.weight = int.tryParse(
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
            ),
          ),
        ],
      ),
    );
  }

  Card otherExerciseWidget(File? image, Exercise exercise) {
    return Card(
      margin: const EdgeInsets.all(5),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(exercise.name),
        ),
        leading: ExerciseImage(
          imageFiles: [image],
          index: 0,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(exercise.description),
        ),
        onTap: () {
          selectedExercises.add(
            WorkoutExercise(
              exerciseUID: exercise.uid,
              index: selectedExercises.length,
              recommendedSets: 0,
              recommendedReps: 0,
              weight: 0,
            ),
          );
          exercisesSel.add(exercise);
          exercisesOth.removeWhere((e) => e.uid == exercise.uid);
          setState(() {});
        },
      ),
    );
  }

  IconButton addUpdateButton() {
    return IconButton(
      onPressed: () async {
        if (!nameBloc.isValid()) {
          return Messaging.show(
            message: nameBloc.state.errorText ?? 'Invalid name',
          );
        }
        if (!descriptionBloc.isValid()) {
          return Messaging.show(
            message: descriptionBloc.state.errorText ?? 'Invalid description',
          );
        }
        try {
          // sort exercises by index
          selectedExercises.sort((a, b) => a.index.compareTo(b.index));

          Workout workout = Workout(
            uid: widget.workout?.uid ??
                WorkoutRepository.collectionReference.doc().id,
            name: nameBloc.state.text ?? '-',
            description: descriptionBloc.state.text ?? '-',
            schedule: selectedSchedule.first,
            workoutExercises: selectedExercises,
          );
          if (widget.workout != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(UserRepository.currentUserUID)
                .collection('workouts')
                .doc(widget.workout!.uid)
                .update(workout.toJson());
          } else {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(UserRepository.currentUserUID)
                .collection('workouts')
                .add(workout.toJson());
          }
          Messaging.show(
            message: 'Exercise ${widget.workout == null ? 'added' : 'updated'}',
          );

          Navigation.flush(widget: const HomeScreen());
        } catch (e) {
          Messaging.show(
            message:
                'Error ${widget.workout == null ? 'adding' : 'updating'} workout: $e',
          );
        }
      },
      icon: Icon(
        widget.workout != null ? Icons.save_rounded : Icons.add_rounded,
        color: context.theme.colorScheme.primary,
      ),
    );
  }

  IconButton deleteButton() {
    return IconButton(
      onPressed: () => Navigation.pushPopup(
        widget: DeleteWorkoutPopup(widget: widget),
      ),
      icon: Icon(Icons.delete_rounded, color: context.theme.colorScheme.error),
    );
  }
}

class DeleteWorkoutPopup extends StatelessWidget {
  const DeleteWorkoutPopup({
    super.key,
    required this.widget,
  });

  final UserWorkoutAddScreen widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Delete Workout',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            const Text(
              'Are you sure you want to delete this workout?',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                if (widget.workout != null) {
                  // delete exercise from database
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(UserRepository.currentUserUID)
                      .collection('workouts')
                      .doc(widget.workout!.uid)
                      .delete();
                }

                Navigation.flush(widget: const HomeScreen());
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
