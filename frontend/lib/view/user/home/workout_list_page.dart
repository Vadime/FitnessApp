import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/models/src/schedule.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/user/home/workout_info_screen.dart';
import 'package:flutter/material.dart';

class UserWorkoutsPage extends StatelessWidget {
  const UserWorkoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ScrollPhysics(),
      children: [
        const SafeArea(
          bottom: false,
          child: SizedBox(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Text('Your Workouts', style: context.textTheme.bodyMedium),
        ),
        StreamBuilder<List<Workout>>(
          stream: UserRepository.currentUserCustomWorkouts,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            var workouts = snapshot.data!;
            if (workouts.isEmpty) {
              return SizedBox(
                height: 100,
                child: Center(
                  child: Text(
                    'No favorites yet',
                    style: context.textTheme.labelSmall,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: workouts.length,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ListTile(
                        title: Text(workouts[index].name),
                        subtitle: Text(workouts[index].description),
                        onTap: () => Navigation.push(
                          widget: WorkoutInfoScreen(
                            workout: workouts[index],
                            isAlreadyCopied: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Text(
                          workouts[index].schedule.strName,
                          style: context.textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Text('All Workouts', style: context.textTheme.bodyMedium),
        ),
        StreamBuilder<List<Workout>>(
          stream: WorkoutRepository.streamWorkouts,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            var workouts = snapshot.data!;
            return ListView.builder(
              physics: const ScrollPhysics(),
              itemCount: workouts.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ListTile(
                        title: Text(workouts[index].name),
                        subtitle: Text(workouts[index].description),
                        onTap: () => Navigation.push(
                          widget: WorkoutInfoScreen(
                            workout: workouts[index],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Text(
                          workouts[index].schedule.strName,
                          style: context.textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
