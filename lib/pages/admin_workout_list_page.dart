import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/admin_workout_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AdminWorkoutListPage extends StatefulWidget {
  const AdminWorkoutListPage({super.key});

  @override
  State<AdminWorkoutListPage> createState() => _AdminWorkoutListPageState();
}

class _AdminWorkoutListPageState extends State<AdminWorkoutListPage>
    with AutomaticKeepAliveClientMixin {
  List<Workout>? workouts;

  @override
  void initState() {
    super.initState();
    loadWorkouts();
  }

  loadWorkouts() async {
    if (!mounted) return;
    workouts = await WorkoutRepository.adminWorkoutsAsFuture;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (workouts == null) {
      return const LoadingWidget();
    }
    if (workouts!.isEmpty) {
      return const FailWidget(
        'No workouts found',
      );
    }

    return ListView.builder(
      itemCount: workouts!.length,
      padding: const EdgeInsets.all(20).add(context.safeArea),
      itemBuilder: (context, index) {
        return ListTileWidget(
          title: workouts![index].name,
          subtitle: workouts![index].description,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          onTap: () => Navigation.push(
            widget: AdminWorkoutAddScreen(
              workout: workouts![index],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
