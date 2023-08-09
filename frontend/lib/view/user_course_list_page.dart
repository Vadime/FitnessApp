import 'dart:io';

import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/models/src/course.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/exercise_image.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserCourseListPage extends StatefulWidget {
  const UserCourseListPage({super.key});

  @override
  State<UserCourseListPage> createState() => _UserCourseListPageState();
}

class _UserCourseListPageState extends State<UserCourseListPage> {
  Map<Tupel<Course, File?>, bool>? courses;

  @override
  void initState() {
    super.initState();
    loadCourses();
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

    return ListView(
      padding: const EdgeInsets.all(20).addSafeArea(context),
      children: [
        const Text('Deine Kurse'),
        const SizedBox(height: 10),
        if (courses!.entries.where((element) => element.value).isEmpty)
          const SizedBox(
            height: 100,
            child: MyErrorWidget(error: 'Du nimmst an keinen Kursen teil'),
          )
        else
          for (var entry in courses!.entries.where((element) => element.value))
            courseListTile(entry),
        const SizedBox(height: 10),
        const Text('Weitere Kurse'),
        const SizedBox(height: 10),
        if (courses!.entries.where((element) => !element.value).isEmpty)
          const SizedBox(
            height: 100,
            child: MyErrorWidget(error: 'Keine weiteren Kurse gefunden'),
          )
        else
          for (var entry in courses!.entries.where((element) => !element.value))
            courseListTile(entry)
      ],
    );
  }

  loadCourses() async {
    var courseList = await CourseRepository.coursesAsFuture;

    for (var course in courseList) {
      var image = await CourseRepository.getCourseImage(course);
      if (!mounted) return;
      (courses ??= {}).putIfAbsent(
        Tupel(course, image),
        () => course.userUIDS.contains(UserRepository.currentUser!.uid),
      );
      if (mounted) setState(() {});
    }
  }

  Widget courseListTile(MapEntry<Tupel<Course, File?>, bool> entry) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${(entry.key.t1.userUIDS.length)} Personen - ${(entry.key.t1.date)}',
            style: context.textTheme.labelSmall,
          ),
          const SizedBox(height: 10),
          MyListTile(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            title: entry.key.t1.name,
            subtitle: entry.key.t1.description,
            trailing: ExerciseImage(image: entry.key.t2),
            onTap: () => Navigation.pushPopup(
              widget: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      !entry.value
                          ? 'Möchtest du dem Kurs "${entry.key.t1.name}" wirklich beitreten?'
                          : 'Möchtest du den Kurs ${entry.key.t1.name} wirklich verlassen?',
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (entry.value) {
                          await CourseRepository.leaveCourse(
                            entry.key.t1,
                            UserRepository.currentUser,
                          );
                          entry.key.t1.userUIDS
                              .remove(UserRepository.currentUser!.uid);
                        } else {
                          await CourseRepository.enterCourse(
                            entry.key.t1,
                            UserRepository.currentUser,
                          );
                          entry.key.t1.userUIDS
                              .add(UserRepository.currentUser!.uid);
                        }

                        courses![entry.key] = !entry.value;
                        setState(() {});
                        Navigation.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !entry.value
                            ? context.theme.primaryColor
                            : Colors.red,
                      ),
                      child: Text(
                        !entry.value ? 'Beitreten' : 'Verlassen',
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
}
