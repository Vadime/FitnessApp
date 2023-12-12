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
  List<Workout>? userWorkouts;
  List<Workout>? adminWorkouts;

  @override
  void initState() {
    super.initState();
    loadWorkouts();
  }

  loadWorkouts() async {
    if (!mounted) return;
    userWorkouts = await UserRepository.currentUserCustomWorkoutsAsFuture;
    if (mounted) setState(() {});
    adminWorkouts = await WorkoutRepository.adminWorkoutsAsFuture;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollViewWidget(
      maxInnerWidth: 600,
      children: [
        const TextWidget(
          'Deine Trainingspläne',
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
        if (userWorkouts == null)
          const SizedBox(
            height: 100,
            child: LoadingWidget(),
          )
        else if (userWorkouts!.isEmpty)
          const SizedBox(
            height: 100,
            child: FailWidget(
              'Noch keine Favoriten',
            ),
          )
        else
          for (var u in userWorkouts!) workoutListTile(u, true),
        const TextWidget(
          'Alle Trainingspläne',
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
        if (adminWorkouts == null)
          const SizedBox(
            height: 100,
            child: LoadingWidget(),
          )
        else if (adminWorkouts!.isEmpty)
          const SizedBox(
            height: 100,
            child: FailWidget(
              'Noch keine Trainingspläne',
            ),
          )
        else
          for (var u in adminWorkouts!) workoutListTile(u, false),
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
