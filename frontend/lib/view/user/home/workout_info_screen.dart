import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/models/src/schedule.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin/home/exercise_image.dart';
import 'package:fitness_app/view/user/home/workout_add_screen.dart';
import 'package:fitness_app/view/user/home/workout_in_progress_screen.dart';
import 'package:flutter/material.dart';

class WorkoutInfoScreen extends StatefulWidget {
  final Workout workout;
  final bool isAlreadyCopied;
  const WorkoutInfoScreen({
    required this.workout,
    this.isAlreadyCopied = false,
    super.key,
  });

  @override
  State<WorkoutInfoScreen> createState() => _WorkoutInfoScreenState();
}

class _WorkoutInfoScreenState extends State<WorkoutInfoScreen> {
  bool copied = false;
  List<Exercise> exercises = [];
  List<File?> images = [];

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  loadExercises() async {
    for (WorkoutExercise w in widget.workout.workoutExercises) {
      var doc = await FirebaseFirestore.instance
          .collection('exercises')
          .doc(w.exerciseUID)
          .get();
      if (doc.data() == null) return;
      Exercise exercise = Exercise.fromJson(
        doc.id,
        doc.data()!,
      );
      exercises.add(exercise);
      setState(() {});
      var image = await ExerciseRepository.getExerciseImage(exercise);
      images.add(image);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.workout.name),
        actions: [
          if (widget.isAlreadyCopied)
            IconButton(
              onPressed: () async {
                Navigation.push(
                  widget: UserWorkoutAddScreen(
                    workout: widget.workout,
                  ),
                );
              },
              icon: const Icon(Icons.edit_rounded),
            )
          else
            IconButton(
              onPressed: () async {
                // copy workout to users workouts
                setState(() {
                  copied = true;
                });
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(UserRepository.currentUserUID)
                    .collection('workouts')
                    .add(widget.workout.toJson());

                Navigation.pop();
              },
              icon: !copied
                  ? const Icon(Icons.copy_rounded)
                  : const Icon(Icons.check_rounded, color: Colors.green),
            )
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: ElevatedButton(
            onPressed: () {
              Navigation.push(
                widget: WorkoutInProgressScreen(
                  workout: widget.workout,
                ),
              );
            },
            child: const Text('Start Workout'),
          ),
        ),
      ),
      body: ListView(
        physics: const ScrollPhysics(),
        children: [
          const SafeArea(
            bottom: false,
            child: SizedBox.shrink(),
          ),
          // workout description
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Description'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(widget.workout.description),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(
                  color: context.theme.cardColor.withOpacity(0.5),
                ),
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Schedule'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(widget.workout.schedule.strName),
                  ),
                ],
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Exercises'),
          ),
          // workout exercises

          if (exercises.isEmpty)
            const Center(child: CircularProgressIndicator.adaptive())
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: exercises.length,
              padding: const EdgeInsets.fromLTRB(
                10,
                0,
                10,
                0,
              ),
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(exercises[index].name),
                        subtitle: Text(exercises[index].description),
                        tileColor: context.theme.highlightColor,
                        trailing: ExerciseImage(
                          imageFiles: images,
                          index: index,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(6),
                          },
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text('Sets'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    widget.workout.workoutExercises[index]
                                        .recommendedSets
                                        .toString(),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text('Reps'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    widget.workout.workoutExercises[index]
                                        .recommendedReps
                                        .toString(),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text('Weights'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    widget
                                        .workout.workoutExercises[index].weight
                                        .toString(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  //  FirebaseFirestore.instance.collection('exercises').snapshots();
}
