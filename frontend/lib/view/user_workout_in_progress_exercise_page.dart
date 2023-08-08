import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';

class UserWorkoutInProgressExercisePage extends StatefulWidget {
  final WorkoutExercise workoutExercise;
  const UserWorkoutInProgressExercisePage({
    required this.workoutExercise,
    super.key,
  });

  @override
  State<UserWorkoutInProgressExercisePage> createState() =>
      _UserWorkoutInProgressExercisePageState();
}

class _UserWorkoutInProgressExercisePageState
    extends State<UserWorkoutInProgressExercisePage> {
  Exercise e = Exercise.emptyExercise;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    // get exercise from firebase
    FirebaseFirestore.instance
        .collection('exercises')
        .doc(widget.workoutExercise.exerciseUID)
        .get()
        .then((value) {
      setState(() {
        e = Exercise.fromJson(value.id, value.data()!);
        ExerciseRepository.getExerciseImage(e).then((value) {
          setState(() {
            imageFile = value;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 200,
          child: Image.file(
            imageFile ?? File(''),
            fit: BoxFit.contain,
          ),
        ),
        const Spacer(),
        // alle daten in tabelle anzeigen
        Card(
          margin: const EdgeInsets.all(20),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: context.theme.scaffoldBackgroundColor.withOpacity(0.5),
                ),
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                    child: Text('Name'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                    child: Text(e.name),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                    child: Text('Description'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                    child: Text(e.description),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(
                  color: context.theme.scaffoldBackgroundColor.withOpacity(0.5),
                ),
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                    child: Text('Sets'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                    child:
                        Text(widget.workoutExercise.recommendedSets.toString()),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                    child: Text('Reps'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                    child:
                        Text(widget.workoutExercise.recommendedReps.toString()),
                  ),
                ],
              ),
              TableRow(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                    child: Text('Weights'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                    child: Text(widget.workoutExercise.weight.toString()),
                  ),
                ],
              ),
              TableRow(
                decoration: BoxDecoration(
                  color: context.theme.scaffoldBackgroundColor.withOpacity(0.5),
                ),
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                    child: Text('Muscles'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                    child: Text(e.muscles.map((e) => e.strName).join(', ')),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
