import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/pages/admin_course_add_screen.dart';
import 'package:fitnessapp/utils/course_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AdminCourseListPage extends StatefulWidget {
  const AdminCourseListPage({super.key});

  @override
  State<AdminCourseListPage> createState() => _AdminCourseListPageState();
}

class _AdminCourseListPageState extends State<AdminCourseListPage>
    with AutomaticKeepAliveClientMixin {
  List<CourseUI>? courses;

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  loadCourses() async {
    var courseList = await CourseRepository.coursesAsFuture;
    courses ??= [];
    for (var course in courseList) {
      if (!mounted) return;
      var image = await CourseRepository.getCourseImage(course);
      courses?.add(CourseUI(course, image));
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
        final entry = courses!.elementAt(index);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              entry.course.date.str,
              style: context.textTheme.labelSmall,
            ),
            const SizedBox(height: 10),
            ListTileWidget(
              padding: const EdgeInsets.all(20),
              title: entry.course.name,
              subtitle: entry.course.description,
              trailing: ImageWidget(
                entry.image == null ? null : MemoryImage(entry.image!),
                height: 50,
                width: 50,
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

  @override
  bool get wantKeepAlive => true;
}
