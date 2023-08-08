import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin_workout_add_screen.dart';
import 'package:flutter/material.dart';

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
