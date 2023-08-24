import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/admin_course_add_screen.dart';
import 'package:fitnessapp/pages/admin_course_list_page.dart';
import 'package:fitnessapp/pages/admin_exercise_add_screen.dart';
import 'package:fitnessapp/pages/admin_exercise_list_page.dart';
import 'package:fitnessapp/pages/admin_profile_page.dart';
import 'package:fitnessapp/pages/admin_workout_add_screen.dart';
import 'package:fitnessapp/pages/admin_workout_list_page.dart';
import 'package:fitnessapp/pages/user_course_list_page.dart';
import 'package:fitnessapp/pages/user_exercise_list_page.dart';
import 'package:fitnessapp/pages/user_profile_page.dart';
import 'package:fitnessapp/pages/user_workout_add_screen.dart';
import 'package:fitnessapp/pages/user_workout_list_page.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

Map<UserRole, List<BottomNavigationView>> homeItems = {
  UserRole.admin: [
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
  UserRole.user: [
    const BottomNavigationView(
      title: 'Courses',
      label: 'Courses',
      view: UserCourseListPage(),
      icon: Icons.home_rounded,
      actionIcon: null,
      action: null,
    ),
    BottomNavigationView(
      title: 'Workouts',
      label: 'Workouts',
      view: const UserWorkoutListPage(),
      icon: Icons.sports_gymnastics_rounded,
      actionIcon: Icons.add_rounded,
      action: () => Navigation.push(widget: const UserWorkoutAddScreen()),
    ),
    const BottomNavigationView(
      title: 'Exercises',
      label: 'Exercises',
      view: UserExerciseListPage(),
      icon: Icons.list_rounded,
      actionIcon: null,
      action: null,
    ),
    const BottomNavigationView(
      title: 'Profile',
      label: 'Profile',
      view: UserProfilePage(),
      icon: Icons.person_rounded,
      actionIcon: null,
      action: null,
    ),
  ],
};

class HomeScreen extends StatelessWidget {
  final int initialIndex;
  const HomeScreen({this.initialIndex = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationPage(
      initialIndex: initialIndex,
      views: homeItems[UserRepository.currentUserRole]!,
    );
  }
}
