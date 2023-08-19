import 'package:fitnessapp/bloc/home/home_item.dart';
import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/view/admin_course_add_screen.dart';
import 'package:fitnessapp/view/admin_course_list_page.dart';
import 'package:fitnessapp/view/admin_exercise_add_screen.dart';
import 'package:fitnessapp/view/admin_exercise_list_page.dart';
import 'package:fitnessapp/view/admin_profile_page.dart';
import 'package:fitnessapp/view/admin_workout_add_screen.dart';
import 'package:fitnessapp/view/admin_workout_list_page.dart';
import 'package:fitnessapp/view/footer.dart';
import 'package:fitnessapp/view/user_course_list_page.dart';
import 'package:fitnessapp/view/user_exercise_list_page.dart';
import 'package:fitnessapp/view/user_profile_page.dart';
import 'package:fitnessapp/view/user_workout_add_screen.dart';
import 'package:fitnessapp/view/user_workout_list_page.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

Map<UserRole, List<HomeItem>> homeItems = {
  UserRole.admin: [
    HomeItem(
      title: 'Courses',
      icon: Icons.home_rounded,
      page: const AdminCourseListPage(),
      actions: [
        IconButton(
          onPressed: () =>
              Navigation.push(widget: const AdminCourseAddScreen()),
          icon: const Icon(Icons.add_rounded),
          tooltip: 'Add Course',
        )
      ],
    ),
    HomeItem(
      title: 'Workouts',
      icon: Icons.sports_gymnastics_rounded,
      page: const AdminWorkoutListPage(),
      actions: [
        IconButton(
          onPressed: () =>
              Navigation.push(widget: const AdminWorkoutAddScreen()),
          icon: const Icon(Icons.add_rounded),
          tooltip: 'Add Workout',
        )
      ],
    ),
    HomeItem(
      title: 'Exercises',
      icon: Icons.list_rounded,
      page: const AdminExerciseListPage(),
      actions: [
        IconButton(
          onPressed: () =>
              Navigation.push(widget: const AdminExerciseAddScreen()),
          icon: const Icon(Icons.add_rounded),
          tooltip: 'Add Exercise',
        )
      ],
    ),
    const HomeItem(
      title: 'Profile',
      icon: Icons.person_rounded,
      page: AdminProfilePage(),
    ),
  ],
  UserRole.user: [
    const HomeItem(
      title: 'Courses',
      icon: Icons.home_rounded,
      page: UserCourseListPage(),
    ),
    HomeItem(
      title: 'Workouts',
      icon: Icons.sports_gymnastics_rounded,
      page: const UserWorkoutListPage(),
      actions: [
        IconButton(
          onPressed: () =>
              Navigation.push(widget: const UserWorkoutAddScreen()),
          icon: const Icon(Icons.add_rounded),
          tooltip: 'Add Workout',
        )
      ],
    ),
    const HomeItem(
      title: 'Exercises',
      icon: Icons.list_rounded,
      page: UserExerciseListPage(),
    ),
    const HomeItem(
      title: 'Profile',
      icon: Icons.person_rounded,
      page: UserProfilePage(),
    ),
  ],
};

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({this.initialIndex = 0, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<HomeItem> homePages;
  late PageController pageController;

  @override
  void initState() {
    super.initState();

    homePages = homeItems[UserRepository.currentUserRole]!;
    pageController = PageController(initialPage: widget.initialIndex);
  }

  int get currentIndex => pageController.hasClients
      ? pageController.page!.round()
      : widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        homePages[currentIndex].title,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Navigation.pushPopup(
            widget: const Footer(),
          ),
        ),
        actions: homePages[currentIndex].actions,
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: homePages.map((e) => e.page).toList(),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: currentIndex,
        onTap: (value) async {
          await pageController.animateToPage(
            value,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
          setState(() {});
        },
        items: homePages.map((e) => e.bottomNavigationBarItem).toList(),
      ),
    );
  }
}
