import 'dart:io';

import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/models/src/course.dart';
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
      return const LoadingWidget();
    }

    if (courses!.isEmpty) {
      return const FailWidget(
        'No courses found',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20).add(context.safeArea),
      children: [
        const Text('Deine Kurse'),
        const SizedBox(height: 10),
        if (courses!.entries.where((element) => element.value).isEmpty)
          const SizedBox(
            height: 100,
            child: FailWidget('Du nimmst an keinen Kursen teil'),
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
            child: FailWidget('Keine weiteren Kurse gefunden'),
          )
        else
          for (var entry in courses!.entries.where((element) => !element.value))
            courseListTile(entry),
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
            '${(entry.key.t1.userUIDS.length)} Personen - ${(entry.key.t1.date.toDate())}',
            style: context.textTheme.labelSmall,
          ),
          const SizedBox(height: 10),
          ListTileWidget(
            padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
            title: entry.key.t1.name,
            subtitle: entry.key.t1.description,
            trailing: entry.key.t2 == null
                ? null
                : ImageWidget(
                    FileImage(entry.key.t2!),
                    height: 50,
                    width: 50,
                  ),
            onTap: () => Navigation.pushPopup(
              widget: Column(
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
                          : context.colorScheme.error,
                    ),
                    child: Text(
                      !entry.value ? 'Beitreten' : 'Verlassen',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
}
