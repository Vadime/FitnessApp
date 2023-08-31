import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models_ui/course_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserCourseListPage extends StatefulWidget {
  const UserCourseListPage({super.key});

  @override
  State<UserCourseListPage> createState() => _UserCourseListPageState();
}

class _UserCourseListPageState extends State<UserCourseListPage> {
  List<CourseUI>? enteredCourses;
  List<CourseUI>? notEnteredCourses;

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20).add(context.safeArea),
      children: [
        if (enteredCourses != null) ...[
          const TextWidget(
            'Deine Kurse',
            margin: EdgeInsets.symmetric(vertical: 10),
          ),
          if (enteredCourses!.isEmpty)
            const SizedBox(
              height: 100,
              child: FailWidget('Du nimmst an keinen Kursen teil'),
            )
          else
            for (var entry in enteredCourses!) courseListTile(entry, true),
        ],
        if (enteredCourses != null) ...[
          const TextWidget(
            'Weitere Kurse',
            margin: EdgeInsets.symmetric(vertical: 10),
          ),
          if (notEnteredCourses!.isEmpty)
            const SizedBox(
              height: 100,
              child: FailWidget('Keine weiteren Kurse gefunden'),
            )
          else
            for (var entry in notEnteredCourses!) courseListTile(entry, false),
        ],
      ],
    );
  }

  loadCourses() async {
    var courseList = await CourseRepository.coursesAsFuture;
    enteredCourses ??= [];
    notEnteredCourses ??= [];
    for (var course in courseList) {
      var image = await CourseRepository.getCourseImage(course);
      if (!mounted) return;
      bool entered = course.userUIDS.contains(UserRepository.currentUser!.uid);
      if (entered) {
        enteredCourses!.add(CourseUI(course, image));
      } else {
        notEnteredCourses!.add(CourseUI(course, image));
      }
      if (mounted) setState(() {});
    }
  }

  Widget courseListTile(CourseUI course, bool entered) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${(course.course.userUIDS.length)} Personen - ${(course.course.date.str)}',
            style: context.textTheme.labelSmall,
          ),
          const SizedBox(height: 10),
          ListTileWidget(
            padding: const EdgeInsets.all(20),
            title: course.course.name,
            subtitle: course.course.description,
            trailing: course.image == null
                ? null
                : ImageWidget(
                    MemoryImage(course.image!),
                    height: 50,
                    width: 50,
                  ),
            onTap: () => Navigation.pushPopup(
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    !entered
                        ? 'Möchtest du dem Kurs "${course.course.name}" wirklich beitreten?'
                        : 'Möchtest du den Kurs ${course.course.name} wirklich verlassen?',
                  ),
                  const SizedBox(height: 10),
                  ElevatedButtonWidget(
                    !entered ? 'Beitreten' : 'Verlassen',
                    onPressed: () async {
                      if (entered) {
                        await CourseRepository.leaveCourse(
                          course.course,
                          UserRepository.currentUser,
                        );
                        course.course.userUIDS
                            .remove(UserRepository.currentUser!.uid);
                      } else {
                        await CourseRepository.enterCourse(
                          course.course,
                          UserRepository.currentUser,
                        );
                        course.course.userUIDS
                            .add(UserRepository.currentUser!.uid);
                      }

                      if (entered) {
                        enteredCourses!.remove(course);
                        notEnteredCourses!.add(course);
                      } else {
                        enteredCourses!.add(course);
                        notEnteredCourses!.remove(course);
                      }

                      setState(() {});
                      Navigation.pop();
                    },
                    backgroundColor: !entered
                        ? context.theme.primaryColor
                        : context.config.errorColor,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
}
