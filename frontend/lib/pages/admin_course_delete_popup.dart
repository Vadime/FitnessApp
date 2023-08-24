import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/pages/admin_course_add_screen.dart';
import 'package:fitnessapp/pages/home_screen.dart';
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colorScheme.errorContainer,
          ),
          onPressed: () async {
            if (widget.entry != null) {
              // delete image from storage
              Navigation.pushLoading();
              try {
                await CourseRepository.deleteCourseImage(widget.entry!.key);
                await CourseRepository.deleteCourse(widget.entry!.key);
              } catch (e, s) {
                Logging.logDetails(e.toString(), s);
                Navigation.pushMessage(
                  message: 'Error deleting course: $e',
                );
                return;
              } finally {
                Navigation.pop();
              }
            }
            Navigation.flush(
              widget: const HomeScreen(),
            );
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
