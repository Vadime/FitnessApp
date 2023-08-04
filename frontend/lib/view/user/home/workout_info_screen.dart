import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/database/user_repository.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';

class WorkoutInfoScreen extends StatefulWidget {
  final Workout workout;
  const WorkoutInfoScreen({required this.workout, super.key});

  @override
  State<WorkoutInfoScreen> createState() => _WorkoutInfoScreenState();
}

class _WorkoutInfoScreenState extends State<WorkoutInfoScreen> {
  bool copied = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.workout.name),
        actions: [
          IconButton(
            onPressed: () async {
              // copy workout to users workouts
              setState(() {
                copied = true;
              });
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(UserRepository.currentUserUID)
                  .collection('workouts')
                  .add({
                'name': 'My ${widget.workout.name}',
                'description': widget.workout.description,
                'exerciceUIDs': widget.workout.workoutExercises
                    .map((e) => e.toJson())
                    .toList(),
              });

              Navigation.pop();
            },
            icon: !copied
                ? const Icon(Icons.copy_rounded)
                : const Icon(Icons.check_rounded, color: Colors.green),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SafeArea(
            bottom: false,
            child: SizedBox.shrink(),
          ),
          // workout description
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Description'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(widget.workout.description),
                  ),
                ],
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.all(20),
            child: Text('Exercises'),
          ),
          // workout exercises
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: loadExercises(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              var exercises = snapshot.data!.docs;

              return Expanded(
                child: ListView.builder(
                  itemCount: exercises.length,
                  padding: const EdgeInsets.fromLTRB(
                    10,
                    0,
                    10,
                    0,
                  ),
                  itemBuilder: (context, index) {
                    bool contains = widget.workout.workoutExercises
                        .map((e) => e.exerciseUID)
                        .contains(exercises[index].id);
                    return contains
                        ? Card(
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              title: Text(exercises[index]['name']),
                              subtitle: Text(exercises[index]['description']),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> loadExercises() =>
      FirebaseFirestore.instance.collection('exercises').snapshots();
}
