part of 'home_screen.dart';

class _AdminHomeScreen extends StatelessWidget {
  final int initialIndex;
  const _AdminHomeScreen({this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationPage(
      initialIndex: initialIndex,
      drawerItems: [
        Center(
          child: ImageWidget(
            AssetImage(
              context.config.logoLocation,
            ),
            width: 100,
            height: 100,
          ),
        ),
      ],
      views: [
        BottomNavigationView(
          title: AppLocalizations.of(context)!.courses,
          view: const AdminCourseListPage(),
          icon: Icons.home_rounded,
          actions: [
            IconButtonWidget(
              Icons.add_rounded,
              onPressed: () =>
                  Navigation.push(widget: const AdminCourseAddScreen()),
            ),
          ],
        ),
        BottomNavigationView(
          title: 'Trainingspläne',
          view: const AdminWorkoutListPage(),
          icon: Icons.sports_gymnastics_rounded,
          actions: [
            IconButtonWidget(
              Icons.add_rounded,
              onPressed: () =>
                  Navigation.push(widget: const AdminWorkoutAddScreen()),
            ),
          ],
        ),
        BottomNavigationView(
          title: 'Übungen',
          view: const AdminExerciseListPage(),
          icon: Icons.list_rounded,
          actions: [
            IconButtonWidget(
              Icons.add_rounded,
              onPressed: () =>
                  Navigation.push(widget: const AdminExerciseAddScreen()),
            ),
          ],
        ),
        const BottomNavigationView(
          title: 'Profil',
          view: AdminProfilePage(),
          icon: Icons.person_rounded,
        ),
      ],
    );
  }
}
