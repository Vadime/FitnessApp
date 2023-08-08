import 'package:fitness_app/bloc/home/home_bloc.dart';
import 'package:fitness_app/bloc/home/home_item.dart';
import 'package:fitness_app/database/user_repository.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin_course_add_screen.dart';
import 'package:fitness_app/view/admin_course_list_page.dart';
import 'package:fitness_app/view/admin_exercise_add_screen.dart';
import 'package:fitness_app/view/admin_exercise_list_page.dart';
import 'package:fitness_app/view/admin_profile_page.dart';
import 'package:fitness_app/view/admin_workout_add_screen.dart';
import 'package:fitness_app/view/admin_workout_list_page.dart';
import 'package:fitness_app/view/footer.dart';
import 'package:fitness_app/view/profile_edit_screen.dart';
import 'package:fitness_app/view/user_course_list_page.dart';
import 'package:fitness_app/view/user_exercise_list_page.dart';
import 'package:fitness_app/view/user_profile_page.dart';
import 'package:fitness_app/view/user_workout_add_screen.dart';
import 'package:fitness_app/view/user_workout_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  final int initialIndex;
  const HomeScreen({this.initialIndex = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        Map<UserRole, List<HomeItem>> homeItems = {
          UserRole.admin: [
            HomeItem(
              title: 'Courses',
              icon: Icons.home_rounded,
              page: const AdminCourseListPage(),
              action: IconButton(
                onPressed: () =>
                    Navigation.push(widget: const AdminCourseAddScreen()),
                icon: const Icon(Icons.add_rounded),
                tooltip: 'Add Course',
              ),
            ),
            HomeItem(
              title: 'Workouts',
              icon: Icons.sports_gymnastics_rounded,
              page: const AdminWorkoutListPage(),
              action: IconButton(
                onPressed: () =>
                    Navigation.push(widget: const AdminWorkoutAddScreen()),
                icon: const Icon(Icons.add_rounded),
                tooltip: 'Add Workout',
              ),
            ),
            HomeItem(
              title: 'Exercises',
              icon: Icons.list_rounded,
              page: const AdminExerciseListPage(),
              action: IconButton(
                onPressed: () =>
                    Navigation.push(widget: const AdminExerciseAddScreen()),
                icon: const Icon(Icons.add_rounded),
                tooltip: 'Add Exercise',
              ),
            ),
            HomeItem(
              title: 'Profile',
              icon: Icons.person_rounded,
              page: const AdminProfilePage(),
              action: IconButton(
                onPressed: () =>
                    Navigation.push(widget: const ProfileEditScreen()),
                icon: const Icon(Icons.edit_rounded),
                tooltip: 'Edit Profile',
              ),
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
              action: IconButton(
                onPressed: () =>
                    Navigation.push(widget: const UserWorkoutAddScreen()),
                icon: const Icon(Icons.add_rounded),
                tooltip: 'Add Workout',
              ),
            ),
            const HomeItem(
              title: 'Exercises',
              icon: Icons.list_rounded,
              page: UserExerciseListPage(),
            ),
            HomeItem(
              title: 'Profile',
              icon: Icons.person_rounded,
              page: const UserProfilePage(),
              action: IconButton(
                onPressed: () =>
                    Navigation.push(widget: const ProfileEditScreen()),
                icon: const Icon(Icons.edit_rounded),
                tooltip: 'Edit Profile',
              ),
            ),
          ],
        };
        return HomeBloc(
          initialIndex: initialIndex,
          homePages: homeItems[UserRepository.currentUserRole]!,
        );
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Navigation.pushPopup(
                  widget: const Footer(),
                ),
              ),
              title: Text(
                state.title,
              ),
              actions: [
                state.action ?? const SizedBox(),
              ],
            ),
            body: state.page,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.fromLTRB(
                30,
                0,
                30,
                10,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  20,
                ),
                child: BottomNavigationBar(
                  currentIndex: state.index,
                  onTap: (value) => context.read<HomeBloc>().add(
                        HomePageChangedEvent(
                          index: value,
                        ),
                      ),
                  items: context
                      .read<HomeBloc>()
                      .homePages
                      .map(
                        (e) => e.bottomNavigationBarItem,
                      )
                      .toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
