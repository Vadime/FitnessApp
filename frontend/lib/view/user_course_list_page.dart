import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/database/course_repository.dart';
import 'package:fitness_app/models/src/course.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/exercise_image.dart';
import 'package:flutter/material.dart';

class UserCourseListPage extends StatefulWidget {
  const UserCourseListPage({super.key});

  @override
  State<UserCourseListPage> createState() => _UserCourseListPageState();
}

class _UserCourseListPageState extends State<UserCourseListPage> {
  List<Course>? courses;
  List<File?> imageFiles = [];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('courses').get().then(
      (value) {
        courses =
            value.docs.map((e) => Course.fromJson(e.id, e.data())).toList();
        setState(() {});
        for (int i = 0; i < courses!.length; i++) {
          CourseRepository.getCourseImage(courses![i]).then(
            (value) => setState(() => imageFiles.insert(i, value)),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (courses == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (courses!.isEmpty) {
      return Center(
        child: Text(
          'No courses found',
          style: context.textTheme.labelSmall,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10).addSafeArea(context),
      itemCount: courses!.length,
      itemBuilder: (context, index) {
        final e = courses![index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                e.date,
                style: context.textTheme.labelSmall,
              ),
            ),
            Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                title: Text(e.name),
                subtitle: Text(e.description),
                trailing: ExerciseImage(imageFiles: imageFiles, index: index),
              ),
            ),
          ],
        );
      },
    );
  }
}
