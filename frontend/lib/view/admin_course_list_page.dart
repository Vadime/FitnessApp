import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/database/course_repository.dart';
import 'package:fitness_app/models/src/course.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin_course_add_screen.dart';
import 'package:fitness_app/view/exercise_image.dart';
import 'package:flutter/material.dart';

class AdminCourseListPage extends StatefulWidget {
  const AdminCourseListPage({super.key});

  @override
  State<AdminCourseListPage> createState() => _AdminCourseListPageState();
}

class _AdminCourseListPageState extends State<AdminCourseListPage> {
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
        return Card(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                title: Text(e.name),
                subtitle: Text(e.description),
                trailing: ExerciseImage(imageFiles: imageFiles, index: index),
                onTap: () {
                  Navigation.push(
                    widget: AdminCourseAddScreen(
                      course: e,
                      imageFile: imageFiles.elementAtOrNull(index),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Text(
                  e.date,
                  style: context.textTheme.labelSmall,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
