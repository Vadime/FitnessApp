import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin_workout_add_screen.dart';
import 'package:fitness_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AdminWorkoutListPage extends StatefulWidget {
  const AdminWorkoutListPage({super.key});

  @override
  State<AdminWorkoutListPage> createState() => _AdminWorkoutListPageState();
}

class _AdminWorkoutListPageState extends State<AdminWorkoutListPage> {
  List<Workout>? workouts;

  @override
  void initState() {
    super.initState();
    loadWorkouts();
  }

  loadWorkouts() async {
    workouts = await WorkoutRepository.adminWorkoutsAsFuture;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (workouts == null) {
      return const MyLoadingWidget();
    }
    if (workouts!.isEmpty) {
      return const MyErrorWidget(
        error: 'No workouts found',
      );
    }

    return ListView.builder(
      itemCount: workouts!.length,
      padding: const EdgeInsets.all(20).addSafeArea(context),
      itemBuilder: (context, index) {
        return MyListTile(
          title: workouts![index].name,
          subtitle: workouts![index].description,
          margin: const EdgeInsets.only(bottom: 20),
          onTap: () => Navigation.push(
            widget: AdminWorkoutAddScreen(
              workout: workouts![index],
            ),
          ),
        );
      },
    );
  }
}
