import 'package:fitnessapp/pages/admin_course_add_screen.dart';
import 'package:fitnessapp/pages/admin_course_list_page.dart';
import 'package:fitnessapp/pages/admin_exercise_add_screen.dart';
import 'package:fitnessapp/pages/admin_exercise_list_page.dart';
import 'package:fitnessapp/pages/admin_profile_page.dart';
import 'package:fitnessapp/pages/admin_workout_add_screen.dart';
import 'package:fitnessapp/pages/admin_workout_list_page.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AdminHomeScreen extends StatelessWidget {
  final int initialIndex;
  const AdminHomeScreen({this.initialIndex = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationPage(
      initialIndex: initialIndex,
      views: [
        BottomNavigationView(
          title: 'Courses',
          label: 'Courses',
          view: const AdminCourseListPage(),
          icon: Icons.home_rounded,
          actionIcon: Icons.add_rounded,
          action: () => Navigation.push(widget: const AdminCourseAddScreen()),
        ),
        BottomNavigationView(
          title: 'Workouts',
          label: 'Workouts',
          view: const AdminWorkoutListPage(),
          icon: Icons.sports_gymnastics_rounded,
          actionIcon: Icons.add_rounded,
          action: () => Navigation.push(widget: const AdminWorkoutAddScreen()),
        ),
        BottomNavigationView(
          title: 'Exercises',
          label: 'Exercises',
          view: const AdminExerciseListPage(),
          icon: Icons.list_rounded,
          actionIcon: Icons.add_rounded,
          action: () => Navigation.push(widget: const AdminExerciseAddScreen()),
        ),
        const BottomNavigationView(
          title: 'Profile',
          label: 'Profile',
          view: AdminProfilePage(),
          icon: Icons.person_rounded,
          actionIcon: null,
          action: null,
        ),
      ],
    );
  }
}
