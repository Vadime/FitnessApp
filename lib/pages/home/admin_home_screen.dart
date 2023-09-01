part of 'home_screen.dart';

class _AdminHomeScreen extends StatelessWidget {
  final int initialIndex;
  const _AdminHomeScreen({this.initialIndex = 0});

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
        BottomNavigationView(
          title: 'Profile',
          label: 'Profile',
          view: const AdminProfilePage(),
          icon: Icons.person_rounded,
          actionIcon: Icons.adaptive.more_rounded,
          action: () {
            Navigation.pushPopup(widget: const BrandingPopup());
            return;
          },
        ),
      ],
    );
  }
}
