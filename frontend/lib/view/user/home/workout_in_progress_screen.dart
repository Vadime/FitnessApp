import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/models/src/workout_difficulty.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/both/home/home_screen.dart';
import 'package:flutter/material.dart';

class WorkoutInProgressScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutInProgressScreen({
    required this.workout,
    super.key,
  });

  @override
  State<WorkoutInProgressScreen> createState() =>
      _WorkoutInProgressScreenState();
}

class _WorkoutInProgressScreenState extends State<WorkoutInProgressScreen> {
  PageController pageController = PageController();

  // get index of current page
  int currentPageIndex = 0;

  // step value
  double get stepValue => 1 / widget.workout.workoutExercises.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: stepValue * currentPageIndex + stepValue,
            color: Theme.of(context).primaryColor,
            semanticsValue:
                '$currentPageIndex/${widget.workout.workoutExercises.length}',
            semanticsLabel: 'Workout Progress',
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (_) => setState(() => currentPageIndex = _),
              children: widget.workout.workoutExercises
                  .map(
                    (e) => WorkoutExercisePage(
                      workoutExercise: e,
                    ),
                  )
                  .toList(),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentPageIndex > 0)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text('Previous'),
                        ),
                      ),
                    ),
                  if (currentPageIndex <
                      widget.workout.workoutExercises.length - 1)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text('Next'),
                        ),
                      ),
                    ),
                  if (currentPageIndex ==
                      widget.workout.workoutExercises.length - 1)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigation.pushPopup(
                              widget: WorkoutFinishedPopup(
                                workout: widget.workout,
                              ),
                            );
                          },
                          child: const Text('Finish'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WorkoutFinishedPopup extends StatefulWidget {
  final Workout workout;

  const WorkoutFinishedPopup({
    required this.workout,
    super.key,
  });

  @override
  State<WorkoutFinishedPopup> createState() => _WorkoutFinishedPopupState();
}

class _WorkoutFinishedPopupState extends State<WorkoutFinishedPopup> {
  WorkoutDifficulty? selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Congratulations!',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            const Text('You have finished your workout! How was it?'),
            const SizedBox(height: 10),
            // WorkoutDifficulty
            SegmentedButton<WorkoutDifficulty>(
              segments: [
                for (WorkoutDifficulty dif in WorkoutDifficulty.values)
                  ButtonSegment(
                    label: Text(dif.name),
                    value: dif,
                  ),
              ],
              emptySelectionAllowed: true,
              selected: selectedDifficulty == null ? {} : {selectedDifficulty!},
              multiSelectionEnabled: false,
              onSelectionChanged: (v) =>
                  setState(() => selectedDifficulty = v.first),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: selectedDifficulty == null
                  ? null
                  : () async {
                      // save workout to firebase
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(UserRepository.currentUserUID)
                          .collection('workoutStatistics')
                          .add({
                        'uid': widget.workout.uid,
                        'difficulty': selectedDifficulty!.name,
                        'date': DateTime.now().formattedDate,
                      });
                      Navigation.push(widget: const HomeScreen());
                    },
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: context.theme.disabledColor,
              ),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutExercisePage extends StatefulWidget {
  final WorkoutExercise workoutExercise;
  const WorkoutExercisePage({
    required this.workoutExercise,
    super.key,
  });

  @override
  State<WorkoutExercisePage> createState() => _WorkoutExercisePageState();
}

class _WorkoutExercisePageState extends State<WorkoutExercisePage> {
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
