import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/database/user_repository.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/user/home/workout_add_screen.dart';
import 'package:fitness_app/view/user/home/workout_info_screen.dart';
import 'package:flutter/material.dart';

class UserWorkoutsPage extends StatelessWidget {
  const UserWorkoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SafeArea(
          bottom: false,
          child: SizedBox(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Text('Your Workouts', style: context.textTheme.bodyMedium),
        ),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: loadUserWorkouts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            var workouts = snapshot.data!.docs;
            return ListView.builder(
              itemCount: workouts.length,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(workouts[index]['name']),
                    subtitle: Text(workouts[index]['description']),
                    onTap: () => Navigation.push(
                      widget: UserWorkoutAddScreen(
                        workout: Workout.fromJson(
                          workouts[index].id,
                          workouts[index].data(),
                        ),
                      ),
                    ),
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
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: loadWorkouts(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            var workouts = snapshot.data!.docs;
            return ListView.builder(
              physics: const ScrollPhysics(),
              itemCount: workouts.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(workouts[index]['name']),
                    subtitle: Text(workouts[index]['description']),
                    onTap: () => Navigation.push(
                      widget: WorkoutInfoScreen(
                        workout: Workout.fromJson(
                          workouts[index].id,
                          workouts[index].data(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> loadUserWorkouts() =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .collection('workouts')
          .snapshots();

  // Nimm alle Workouts aus einer Collection
  Stream<QuerySnapshot<Map<String, dynamic>>> loadWorkouts() =>
      FirebaseFirestore.instance.collection('workouts').snapshots();
}
