import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin_workout_add_screen.dart';
import 'package:flutter/material.dart';

class AdminWorkoutListPage extends StatefulWidget {
  const AdminWorkoutListPage({super.key});

  @override
  State<AdminWorkoutListPage> createState() => _AdminWorkoutListPageState();
}

class _AdminWorkoutListPageState extends State<AdminWorkoutListPage> {
  late Stream<List<Workout>> workoutStream;

  @override
  void initState() {
    super.initState();
    workoutStream = WorkoutRepository.streamWorkouts;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Workout>>(
      stream: workoutStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Workout>? workouts = snapshot.data;

        if (snapshot.data == null || workouts!.isEmpty) {
          return Center(
            child: Text(
              'No workouts found',
              style: context.textTheme.labelSmall,
            ),
          );
        }

        return ListView.builder(
          itemCount: workouts.length,
          padding: const EdgeInsets.all(10).addSafeArea(context),
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(workouts[index].name),
                subtitle: Text(workouts[index].description),
                onTap: () => Navigation.push(
                  widget: AdminWorkoutAddScreen(
                    workout: workouts[index],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
