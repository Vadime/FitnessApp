import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/utils/course_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserCourseListPage extends StatefulWidget {
  const UserCourseListPage({super.key});

  @override
  State<UserCourseListPage> createState() => _UserCourseListPageState();
}

class _UserCourseListPageState extends State<UserCourseListPage>
    with AutomaticKeepAliveClientMixin {
  List<CourseUI>? enteredCourses;
  List<CourseUI>? notEnteredCourses;

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ScrollViewWidget(
      maxInnerWidth: 600,
      children: [
        const TextWidget(
          'Deine Kurse',
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
        if (enteredCourses == null)
          const SizedBox(
            height: 100,
            child: LoadingWidget(),
          )
        else if (enteredCourses!.isEmpty)
          const SizedBox(
            height: 100,
            child: FailWidget('Du nimmst an keinen Kursen teil'),
          )
        else
          for (var entry in enteredCourses!) courseListTile(entry, true),
        const TextWidget(
          'Weitere Kurse',
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
        if (enteredCourses == null)
          const SizedBox(
            height: 100,
            child: LoadingWidget(),
          )
        else if (notEnteredCourses!.isEmpty)
          const SizedBox(
            height: 100,
            child: FailWidget('Keine weiteren Kurse gefunden'),
          )
        else
          for (var entry in notEnteredCourses!) courseListTile(entry, false),
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
          TextWidget(
            '${(course.course.userUIDS.length)} Personen - ${(course.course.date.ddMMYYYY)}',
            style: context.textTheme.labelSmall,
          ),
          const SizedBox(height: 10),
          ListTileWidget(
            slideMenuItems: [
              if (entered)
                SlideMenuItem(
                  color: context.config.errorColor,
                  child: const FittedBox(
                    child: TextWidget(
                      'Verlassen',
                      color: Colors.white,
                      weight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    await CourseRepository.leaveCourse(
                      course.course,
                      UserRepository.currentUser,
                    );
                    course.course.userUIDS
                        .remove(UserRepository.currentUser!.uid);

                    enteredCourses!.remove(course);
                    notEnteredCourses!.add(course);

                    setState(() {});
                  },
                )
              else
                SlideMenuItem(
                  color: context.config.primaryColor,
                  child: const FittedBox(
                    child: TextWidget(
                      'Beitreten',
                      color: Colors.white,
                      weight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    await CourseRepository.enterCourse(
                      course.course,
                      UserRepository.currentUser,
                    );
                    course.course.userUIDS.add(UserRepository.currentUser!.uid);

                    enteredCourses!.add(course);
                    notEnteredCourses!.remove(course);

                    setState(() {});
                  },
                ),
            ],
            padding: const EdgeInsets.all(10),
            contentPadding: const EdgeInsets.all(10),
            title: course.course.name,
            subtitle: course.course.description,
            trailing: course.image == null
                ? null
                : ImageWidget(
                    MemoryImage(course.image!),
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.only(right: 10),
                  ),
          ),
          const SizedBox(height: 10),
        ],
      );

  @override
  bool get wantKeepAlive => true;
}
