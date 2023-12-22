part of 'home_screen.dart';

class _UserHomeScreen extends StatelessWidget {
  final int initialIndex;
  const _UserHomeScreen({this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationPage(
      initialIndex: initialIndex,
      views: [
        // BottomNavigationView(
        //   title: AppLocalizations.of(context)!.courses,
        //   view: const UserCourseListPage(),
        //   icon: Icons.home_rounded,
        // ),
        BottomNavigationView(
          title: 'Trainingspläne',
          view: const UserWorkoutListPage(),
          icon: Icons.sports_gymnastics_rounded,
          actions: [
            IconButtonWidget(
              Icons.add_rounded,
              onPressed: () =>
                  Navigation.push(widget: const UserWorkoutAddScreen()),
            ),
          ],
        ),
        BottomNavigationView(
          title: 'Übungen',
          view: const UserExerciseListPage(),
          icon: Icons.list_rounded,
          actions: [
            IconButtonWidget(
              Icons.add_rounded,
              onPressed: () =>
                  Navigation.push(widget: const UserExerciseAddScreen()),
            ),
          ],
        ),
        BottomNavigationView(
          title: 'Health',
          view: const UserHealthPage(),
          icon: Icons.apple_rounded,
          actions: [
            IconButtonWidget(
              Icons.edit_rounded,
              onPressed: () {
                User? user = UserRepository.currentUser;
                if (user == null) {
                  return;
                }
                Navigation.push(widget: const UserHealthEditScreen());
              },
            ),
          ],
        ),
        BottomNavigationView(
          title: 'Freunde',
          view: const UserFriendListPage(),
          icon: Icons.people_rounded,
          actions: [
            IconButtonWidget(
              Icons.add_rounded,
              onPressed: () {
                Navigation.pushPopup(
                  widget: const UserProfileFriendAddPopup(),
                );
                return;
              },
            ),
          ],
        ),
        const BottomNavigationView(
          title: 'Profil',
          view: UserProfilePage(),
          icon: Icons.person_rounded,
        ),
      ],
    );
  }
}
