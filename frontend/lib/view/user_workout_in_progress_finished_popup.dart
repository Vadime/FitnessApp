import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/models/src/workout_difficulty.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/home_screen.dart';
import 'package:flutter/material.dart';

class UserWorkoutInProgressFinishedPopup extends StatefulWidget {
  final Workout workout;

  const UserWorkoutInProgressFinishedPopup({
    required this.workout,
    super.key,
  });

  @override
  State<UserWorkoutInProgressFinishedPopup> createState() =>
      _UserWorkoutInProgressFinishedPopupState();
}

class _UserWorkoutInProgressFinishedPopupState
    extends State<UserWorkoutInProgressFinishedPopup> {
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
