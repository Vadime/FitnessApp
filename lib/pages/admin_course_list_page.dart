import 'dart:typed_data';

import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/src/course.dart';
import 'package:fitnessapp/pages/admin_course_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AdminCourseListPage extends StatefulWidget {
  const AdminCourseListPage({super.key});

  @override
  State<AdminCourseListPage> createState() => _AdminCourseListPageState();
}

class _AdminCourseListPageState extends State<AdminCourseListPage> {
  Map<Course, Uint8List?>? courses;

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
      return const LoadingWidget();
    }

    if (courses!.isEmpty) {
      return const FailWidget(
        'No courses found',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20).add(context.safeArea),
      itemCount: courses!.length,
      itemBuilder: (context, index) {
        final entry = courses!.entries.elementAt(index);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              entry.key.date.toDate(),
              style: context.textTheme.labelSmall,
            ),
            const SizedBox(height: 10),
            ListTileWidget(
              padding: const EdgeInsets.all(20),
              title: entry.key.name,
              subtitle: entry.key.description,
              trailing: entry.value == null
                  ? null
                  : ImageWidget(
                      MemoryImage(entry.value!),
                      height: 40,
                      width: 40,
                    ),
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
