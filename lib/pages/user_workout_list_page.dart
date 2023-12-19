import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/user_workout_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserWorkoutListPage extends StatefulWidget {
  const UserWorkoutListPage({super.key});

  @override
  State<UserWorkoutListPage> createState() => _UserWorkoutListPageState();
}

class _UserWorkoutListPageState extends State<UserWorkoutListPage>
    with AutomaticKeepAliveClientMixin {
  List<Workout>? filteredUserWorkouts;
  List<Workout>? userWorkouts;
  List<Workout>? filteredAdminWorkouts;
  List<Workout>? adminWorkouts;
  TextFieldController searchController =
      TextFieldController('Suche nach Trainingsplänen');

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      filterWorkouts(searchController);
      setState(() {});
    });
    loadWorkouts();
  }

  loadWorkouts() async {
    if (!mounted) return;
    userWorkouts = await UserRepository.currentUserCustomWorkoutsAsFuture;
    filteredUserWorkouts = userWorkouts?.map((w) => w.copy()).toList();
    if (mounted) setState(() {});
    adminWorkouts = await WorkoutRepository.adminWorkoutsAsFuture;
    filteredAdminWorkouts = adminWorkouts?.map((w) => w.copy()).toList();
    if (mounted) setState(() {});
  }

  filterWorkouts(TextFieldController controller) {
    filteredUserWorkouts = userWorkouts
        ?.where((w) => w.name.toLowerCase().contains(controller.text))
        .toList();

    filteredAdminWorkouts = adminWorkouts
        ?.where((w) => w.name.toLowerCase().contains(controller.text))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollViewWidget(
      maxInnerWidth: 600,
      children: [
        // search bar
        // TextFieldWidget(
        //   controller: searchController,
        //   margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        // ),
        const TextWidget(
          'Deine Trainingspläne',
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
        if (filteredUserWorkouts == null)
          const SizedBox(
            height: 100,
            child: LoadingWidget(),
          )
        else if (filteredUserWorkouts!.isEmpty)
          const SizedBox(
            height: 100,
            child: FailWidget(
              'Noch keine Favoriten',
            ),
          )
        else
          for (var u in filteredUserWorkouts!) workoutListTile(u, true),
        const TextWidget(
          'Alle Trainingspläne',
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
        if (filteredAdminWorkouts == null)
          const SizedBox(
            height: 100,
            child: LoadingWidget(),
          )
        else if (filteredAdminWorkouts!.isEmpty)
          const SizedBox(
            height: 100,
            child: FailWidget(
              'Noch keine Trainingspläne',
            ),
          )
        else
          for (var u in filteredAdminWorkouts!) workoutListTile(u, false),
      ],
    );
  }

  Widget workoutListTile(Workout workout, bool userWorkout) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextWidget(
            workout.schedule.str,
            style: context.textTheme.labelSmall,
          ),
          const SizedBox(height: 10),
          ListTileWidget(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            title: workout.name,
            subtitle: workout.description,
            onTap: () => Navigation.push(
              widget: UserWorkoutInfoScreen(
                workout: workout,
                isAlreadyCopied: userWorkout,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      );

  @override
  bool get wantKeepAlive => true;
}
