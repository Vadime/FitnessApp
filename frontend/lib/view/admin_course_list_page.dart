import 'dart:io';

import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/src/course.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin_course_add_screen.dart';
import 'package:fitness_app/view/exercise_image.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AdminCourseListPage extends StatefulWidget {
  const AdminCourseListPage({super.key});

  @override
  State<AdminCourseListPage> createState() => _AdminCourseListPageState();
}

class _AdminCourseListPageState extends State<AdminCourseListPage> {
  Map<Course, File?>? courses;

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  loadCourses() async {
    var courseList = await CourseRepository.coursesAsFuture;
    for (var course in courseList) {
      if (!mounted) return;
      var image = await CourseRepository.getCourseImage(course);
      (courses ??= {}).putIfAbsent(course, () => image);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (courses == null) {
      return const MyLoadingWidget();
    }

    if (courses!.isEmpty) {
      return const MyErrorWidget(
        error: 'No courses found',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20).addSafeArea(context),
      itemCount: courses!.length,
      itemBuilder: (context, index) {
        final entry = courses!.entries.elementAt(index);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              entry.key.date,
              style: context.textTheme.labelSmall,
            ),
            const SizedBox(height: 10),
            MyListTile(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              title: entry.key.name,
              subtitle: entry.key.description,
              trailing: ExerciseImage(image: entry.value),
              onTap: () {
                Navigation.push(
                  widget: AdminCourseAddScreen(
                    entry: entry,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
