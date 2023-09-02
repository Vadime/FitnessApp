part of 'home_screen.dart';

class _UserHomeScreen extends StatelessWidget {
  final int initialIndex;
  const _UserHomeScreen({this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationPage(
      initialIndex: initialIndex,
      views: [
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
        BottomNavigationView(
          title: 'Exercises',
          label: 'Exercises',
          view: const UserExerciseListPage(),
          icon: Icons.list_rounded,
          actionIcon: Icons.add_rounded,
          action: () => Navigation.push(widget: const UserExerciseAddScreen()),
        ),
        BottomNavigationView(
          title: 'Friends',
          label: 'Friends',
          view: const UserFriendListPage(),
          icon: Icons.people_rounded,
          actionIcon: Icons.add,
          action: () {
            Navigation.pushPopup(
              widget: const UserProfileFriendAddPopup(),
            );
            return;
          },
        ),
        BottomNavigationView(
          title: 'Profile',
          label: 'Profile',
          view: const UserProfilePage(),
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
