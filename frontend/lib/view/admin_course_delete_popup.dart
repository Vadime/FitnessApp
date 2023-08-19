import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/utils/src/logging.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/view/admin_course_add_screen.dart';
import 'package:fitnessapp/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

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
              if (widget.entry != null) {
                // delete image from storage
                try {
                  Navigation.disableInput();
                  await CourseRepository.deleteCourseImage(widget.entry!.key);
                  await CourseRepository.deleteCourse(widget.entry!.key);
                  Navigation.enableInput();
                } catch (e, s) {
                  Navigation.enableInput();
                  Logging.error(e, s);

                  Navigation.pushMessage(
                    message: 'Error deleting course: $e',
                  );

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
    );
  }
}
