import 'package:fitness_app/bloc/home/home_bloc.dart';
import 'package:fitness_app/bloc/home/home_item.dart';
import 'package:fitness_app/database/user_repository.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin/home/exercise_add_screen.dart';
import 'package:fitness_app/view/admin/home/exercise_list_page.dart';
import 'package:fitness_app/view/admin/home/profile_page.dart';
import 'package:fitness_app/view/admin/home/workout_add_screen.dart';
import 'package:fitness_app/view/admin/home/workout_list_page.dart';
import 'package:fitness_app/view/both/home/profile_edit_screen.dart';
import 'package:fitness_app/view/both/footer.dart';
import 'package:fitness_app/view/user/home/exercise_list_page.dart';
import 'package:fitness_app/view/user/home/profile_page.dart';
import 'package:fitness_app/view/user/home/workout_add_screen.dart';
import 'package:fitness_app/view/user/home/workout_list_page.dart';
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
              page: const AdminExercisesPage(),
              action: IconButton(
                onPressed: () =>
                    Navigation.push(widget: const AdminAddExercisesScreen()),
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
                    Navigation.push(widget: const EditProfileScreen()),
                icon: const Icon(Icons.edit_rounded),
                tooltip: 'Edit Profile',
              ),
            ),
          ],
          UserRole.user: [
            HomeItem(
              title: 'Workouts',
              icon: Icons.sports_gymnastics_rounded,
              page: const UserWorkoutsPage(),
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
              page: UserExercisesPage(),
            ),
            HomeItem(
              title: 'Profile',
              icon: Icons.person_rounded,
              page: const UserProfilePage(),
              action: IconButton(
                onPressed: () =>
                    Navigation.push(widget: const EditProfileScreen()),
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
                  widget: const HomeFooter(),
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
            bottomNavigationBar: BottomNavigationBar(
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
          );
        },
      ),
    );
  }
}
