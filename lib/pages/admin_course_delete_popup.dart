import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/pages/admin_course_add_screen.dart';
import 'package:fitnessapp/pages/admin_home_screen.dart';
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
    return Column(
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
        ElevatedButtonWidget(
          'Delete',
          backgroundColor: context.config.errorColor,
          onPressed: () async {
            if (widget.entry != null) {
              // delete image from storage
              try {
                await CourseRepository.deleteCourseImage(widget.entry!.course);
                await CourseRepository.deleteCourse(widget.entry!.course);
              } catch (e, s) {
                Logging.logDetails(e.toString(), s);
                Toast.info(
                  'Error deleting course: $e',
                  context: context,
                );
                return;
              }
            }
            Navigation.flush(
              widget: const AdminHomeScreen(),
            );
          },
        ),
      ],
    );
  }
}
