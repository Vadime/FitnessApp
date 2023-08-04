import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/database/user_repository.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserWorkoutAddScreen extends StatefulWidget {
  final Workout? workout;

  const UserWorkoutAddScreen({this.workout, super.key});

  @override
  State<UserWorkoutAddScreen> createState() => _UserWorkoutAddScreenState();
}

class _UserWorkoutAddScreenState extends State<UserWorkoutAddScreen> {
  late NameBloc nameBloc;
  late TextBloc descriptionBloc;
  late List<String> exerciceUIDs;

  @override
  void initState() {
    super.initState();
    nameBloc = NameBloc(
      initialValue: widget.workout?.name,
    );
    descriptionBloc = TextBloc(
      initialValue: widget.workout?.description,
      hint: 'Description',
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Add Workout'),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SafeArea(
                bottom: false,
                child: SizedBox(),
              ),
              Card(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MyTextField(
                        bloc: nameBloc,
                      ),
                      MyTextField(
                        bloc: descriptionBloc,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(
                  'Exercises',
                  style: context.textTheme.bodyMedium,
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: loadExercises(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    var exercises = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: exercises.length,
                      padding: EdgeInsets.fromLTRB(
                        10,
                        0,
                        10,
                        context.bottomInset + 66,
                      ),
                      itemBuilder: (context, index) {
                        bool contains =
                            exerciceUIDs.contains(exercises[index].id);
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(exercises[index]['name']),
                            subtitle: Text(exercises[index]['description']),
                            selected: contains,
                            selectedTileColor: context.theme.highlightColor,
                            onTap: () {
                              if (!contains) {
                                exerciceUIDs.add(exercises[index].id);
                              } else {
                                exerciceUIDs.remove(exercises[index].id);
                              }
                              setState(() {});
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: context.bottomInset,
            left: 10,
            right: 10,
            child: Row(
              children: [
                if (widget.workout != null)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          // delete exercise
                          Navigation.pushPopup(
                            widget: Padding(
                              padding: const EdgeInsets.all(20),
                              child: SafeArea(
                                top: false,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Delete Workout',
                                      style: context.textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Are you sure you want to delete this workout?',
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () async {
                                        if (widget.workout != null) {
                                          // delete exercise from database
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(
                                                UserRepository.currentUserUID,
                                              )
                                              .collection('workouts')
                                              .doc(widget.workout!.uid)
                                              .delete();
                                        }

                                        Navigation.pop();
                                        Navigation.pop();
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Delete Workout'),
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!nameBloc.isValid()) {
                          return Messaging.show(
                            message: nameBloc.state.errorText!,
                          );
                        }
                        if (!descriptionBloc.isValid()) {
                          return Messaging.show(
                            message: descriptionBloc.state.errorText!,
                          );
                        }
                        if (exerciceUIDs.isEmpty) {
                          return Messaging.show(
                            message: 'Please select at least one exercise',
                          );
                        }
                        try {
                          if (widget.workout != null) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(
                                  UserRepository.currentUserUID,
                                )
                                .collection('workouts')
                                .doc(widget.workout!.uid)
                                .update({
                              'name': nameBloc.state.text,
                              'description': descriptionBloc.state.text,
                              'exerciceUIDs': exerciceUIDs,
                            });
                          } else {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(
                                  UserRepository.currentUserUID,
                                )
                                .collection('workouts')
                                .add({
                              'name': nameBloc.state.text,
                              'description': descriptionBloc.state.text,
                              'exerciceUIDs': exerciceUIDs,
                            });
                          }
                          Messaging.show(
                            message:
                                'Exercise ${widget.workout == null ? 'added' : 'updated'}',
                          );
                          Navigation.pop();
                        } catch (e) {
                          Messaging.show(
                            message:
                                'Error ${widget.workout == null ? 'adding' : 'updating'} workout: $e',
                          );
                        }
                      },
                      child: Text(
                        '${widget.workout != null ? 'Save' : 'Add'} Workout',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> loadExercises() =>
      FirebaseFirestore.instance.collection('exercises').snapshots();
}
