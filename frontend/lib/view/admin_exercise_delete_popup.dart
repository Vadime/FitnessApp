import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness_app/utils/src/logging.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin_exercise_add_screen.dart';
import 'package:fitness_app/view/home_screen.dart';
import 'package:flutter/material.dart';

class AdminExerciseDeletePopup extends StatelessWidget {
  const AdminExerciseDeletePopup({
    super.key,
    required this.widget,
  });

  final AdminExerciseAddScreen widget;

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
              'Delete Exercise',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            const Text(
              'Are you sure you want to delete this exercise?',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                if (widget.exercise != null) {
                  // delete image from storage
                  try {
                    await FirebaseStorage.instance
                        .refFromURL(
                          widget.exercise!.imageURL ?? '',
                        )
                        .delete()
                        .catchError((_) {});
                    // delete exercise from database
                    await FirebaseFirestore.instance
                        .collection('exercises')
                        .doc(widget.exercise!.uid)
                        .delete();
                  } catch (e, s) {
                    Logging.error(e, s);
                    Messaging.show(
                      message: 'Error deleting exercise: $e',
                    );
                    Navigation.pop();
                    return;
                  }
                }
                Navigation.flush(
                  widget: const HomeScreen(initialIndex: 2),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
