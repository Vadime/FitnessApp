import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/models/src/schedule.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin/home/exercise_image.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AdminWorkoutAddScreen extends StatefulWidget {
  final Workout? workout;

  const AdminWorkoutAddScreen({this.workout, super.key});

  @override
  State<AdminWorkoutAddScreen> createState() => _AdminWorkoutAddScreenState();
}

class _AdminWorkoutAddScreenState extends State<AdminWorkoutAddScreen> {
  late NameBloc nameBloc;
  late TextBloc descriptionBloc;

  List<File?> imageFiles = [];

  late Stream<List<Exercise>> exerciseStream;

  late List<WorkoutExercise> selectedExercises;
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
    exerciseStream = ExerciseRepository.streamExercises;
    ExerciseRepository.getExercises().then(
      (exercises) {
        for (int i = 0; i < exercises.length; i++) {
          ExerciseRepository.getExerciseImage(exercises[i]).then(
            (value) => setState(() => imageFiles.insert(i, value)),
          );
        }
      },
    );
    selectedExercises = widget.workout?.workoutExercises ?? [];
    selectedSchedule = widget.workout?.schedule != null
        ? {widget.workout!.schedule}
        : {Schedule.daily};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Add Workout'),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              const SafeArea(
                bottom: false,
                child: SizedBox(),
              ),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(
                  'Exercises',
                  style: context.textTheme.bodyMedium,
                ),
              ),
              StreamBuilder<List<Exercise>>(
                stream: exerciseStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<Exercise>? exercises = snapshot.data;

                  if (exercises == null || exercises.isEmpty) {
                    return const Center(child: Text('No exercises found'));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: exercises.length,
                    padding: EdgeInsets.fromLTRB(
                      10,
                      0,
                      10,
                      context.bottomInset + 66,
                    ),
                    itemBuilder: (context, index) {
                      Exercise exercise = exercises[index];
                      bool contains = false;
                      WorkoutExercise? currentExercise;
                      for (WorkoutExercise e in selectedExercises) {
                        if (e.exerciseUID == exercise.uid) {
                          contains = true;
                          currentExercise = e;
                          break;
                        }
                      }

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(exercise.name),
                              trailing: ExerciseImage(
                                imageFiles: imageFiles,
                                index: index,
                              ),
                              subtitle: Text(exercise.description),
                              onTap: () {
                                // add to list
                                if (contains) {
                                  selectedExercises.removeWhere(
                                    (e) => e.exerciseUID == exercise.uid,
                                  );
                                } else {
                                  selectedExercises.add(
                                    currentExercise ??
                                        WorkoutExercise(
                                          exerciseUID: exercise.uid,
                                          recommendedSets: 0,
                                          recommendedReps: 0,
                                        ),
                                  );
                                }
                                setState(() {});
                              },
                              selected: contains,
                              selectedTileColor: context.theme.highlightColor,
                            ),
                            if (contains) ...[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: TextEditingController(
                                          text: currentExercise?.recommendedSets
                                              .toString(),
                                        ),
                                        onChanged: (c) =>
                                            currentExercise?.recommendedSets =
                                                int.tryParse(
                                                      c.toString(),
                                                    ) ??
                                                    0,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'Recommended Sets',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: TextEditingController(
                                          text: currentExercise?.recommendedReps
                                              .toString(),
                                        ),
                                        onChanged: (c) =>
                                            currentExercise?.recommendedReps =
                                                int.tryParse(
                                                      c.toString(),
                                                    ) ??
                                                    0,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'Recommended Reps',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          Positioned(
            bottom: context.bottomInset,
            left: 10,
            right: 10,
            child: Row(
              children: [
                if (widget.workout != null)
                  Expanded(
                    child: deleteButton(),
                  ),
                Expanded(
                  child: addUpdateButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding addUpdateButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: ElevatedButton(
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
                  .collection('workouts')
                  .doc(widget.workout!.uid)
                  .update(workout.toJson());
            } else {
              await FirebaseFirestore.instance
                  .collection('workouts')
                  .add(workout.toJson());
            }
            Messaging.show(
              message:
                  'Exercise ${widget.workout == null ? 'added' : 'updated'}',
            );
            Navigation.pop();
          } catch (e) {
            Messaging.show(
              message:
                  'Error ${widget.workout == null ? 'adding' : 'updating'} workout: $e',
            );
          }
        },
        child: Text(
          '${widget.workout != null ? 'Save' : 'Add'} Workout',
        ),
      ),
    );
  }

  Padding deleteButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: ElevatedButton(
        onPressed: () => Navigation.pushPopup(
          widget: DeleteWorkoutPopup(widget: widget),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        child: const Text('Delete Workout'),
      ),
    );
  }
}

class DeleteWorkoutPopup extends StatelessWidget {
  const DeleteWorkoutPopup({
    super.key,
    required this.widget,
  });

  final AdminWorkoutAddScreen widget;

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
                      .collection('workouts')
                      .doc(widget.workout!.uid)
                      .delete();
                }

                Navigation.pop();
                Navigation.pop();
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
