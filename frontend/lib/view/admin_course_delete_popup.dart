import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness_app/utils/src/logging.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin_course_add_screen.dart';
import 'package:fitness_app/view/home_screen.dart';
import 'package:flutter/material.dart';

class AdminCourseDeletePopup extends StatelessWidget {
  const AdminCourseDeletePopup({
    super.key,
    required this.widget,
  });

  final AdminCourseAddScreen widget;

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
              'Delete Course',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            const Text(
              'Are you sure you want to delete this course?',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                if (widget.course != null) {
                  // delete image from storage
                  try {
                    await FirebaseStorage.instance
                        .refFromURL(
                          widget.course!.imageURL ?? '',
                        )
                        .delete()
                        .catchError((_) {});
                    // delete exercise from database
                    await FirebaseFirestore.instance
                        .collection('courses')
                        .doc(widget.course!.uid)
                        .delete();
                  } catch (e, s) {
                    Logging.error(e, s);
                    Messaging.show(
                      message: 'Error deleting course: $e',
                    );
                    Navigation.pop();
                    return;
                  }
                }
                Navigation.flush(
                  widget: const HomeScreen(),
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
