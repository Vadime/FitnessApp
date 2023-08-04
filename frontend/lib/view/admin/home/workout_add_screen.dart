import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/bloc/widgets/my_text_field_bloc.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class WorkoutExerciseUI {
  final String exerciceUID;
  final TextBloc recommendedSets;
  final TextBloc recommendedReps;

  WorkoutExerciseUI({
    required this.exerciceUID,
    required this.recommendedSets,
    required this.recommendedReps,
  });
}

class AdminWorkoutAddScreen extends StatefulWidget {
  final Workout? workout;

  const AdminWorkoutAddScreen({this.workout, super.key});

  @override
  State<AdminWorkoutAddScreen> createState() => _AdminWorkoutAddScreenState();
}

class _AdminWorkoutAddScreenState extends State<AdminWorkoutAddScreen> {
  late NameBloc nameBloc;
  late TextBloc descriptionBloc;
  late List<WorkoutExerciseUI> workoutExerciseUIs;

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
                child: StreamBuilder<List<Exercise>>(
                  stream: ExerciseRepository.streamExercises,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data == null) {
                      return const Center(child: Text('No exercises found'));
                    }
                    List<Exercise> exercises = snapshot.data!;

                    return ListView.builder(
                      itemCount: exercises.length,
                      padding: EdgeInsets.fromLTRB(
                        10,
                        0,
                        10,
                        context.bottomInset + 66,
                      ),
                      itemBuilder: (context, index) {
                        Exercise exercise = exercises[index];

                        bool contains = workoutExerciseUIs
                            .map((e) => e.exerciceUID)
                            .contains(exercise.uid);

                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            contentPadding: EdgeInsets.fromLTRB(
                              20,
                              contains ? 20 : 5,
                              20,
                              5,
                            ),
                            minVerticalPadding: 0,
                            title: Text(exercise.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 5),
                                Text(exercise.description),
                                if (contains)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: MyTextField(
                                          bloc: workoutExerciseUIs[index]
                                              .recommendedSets,
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                      Expanded(
                                        child: MyTextField(
                                          bloc: workoutExerciseUIs[index]
                                              .recommendedReps,
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            selected: contains,
                            selectedTileColor: context.theme.highlightColor,
                            trailing: Checkbox(
                              value: contains,
                              onChanged: (value) {
                                if (!contains) {
                                  var workoutExerciseUI = WorkoutExerciseUI(
                                    exerciceUID: exercise.uid,
                                    recommendedSets: TextBloc(
                                      initialValue: '3',
                                      hint: 'Sets',
                                    ),
                                    recommendedReps: TextBloc(
                                      initialValue: '10',
                                      hint: 'Reps',
                                    ),
                                  );
                                  workoutExerciseUIs.add(workoutExerciseUI);
                                } else {
                                  workoutExerciseUIs.removeWhere(
                                    (e) => e.exerciceUID == exercise.uid,
                                  );
                                }
                                setState(() {});
                              },
                            ),
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
                    child: deleteButton(),
                  ),
                Expanded(
                  child: addUpdateButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding addUpdateButton() {
    return Padding(
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
          if (workoutExerciseUIs.isEmpty) {
            return Messaging.show(
              message: 'Please select at least one exercise',
            );
          }
          try {
            if (widget.workout != null) {
              await FirebaseFirestore.instance
                  .collection('workouts')
                  .doc(widget.workout!.uid)
                  .update({
                'name': nameBloc.state.text,
                'description': descriptionBloc.state.text,
                'workoutExercises': workoutExerciseUIs.map((e) {
                  return WorkoutExercise(
                    exerciceUID: e.exerciceUID,
                    recommendedSets: int.tryParse(
                          e.recommendedSets.state.text ?? '0',
                        ) ??
                        0,
                    recommendedReps: int.tryParse(
                          e.recommendedReps.state.text ?? '0',
                        ) ??
                        0,
                  ).toJson();
                }).toList(),
              });
            } else {
              await FirebaseFirestore.instance.collection('workouts').add({
                'name': nameBloc.state.text,
                'description': descriptionBloc.state.text,
                'workoutExercises': workoutExerciseUIs.map((e) {
                  return WorkoutExercise(
                    exerciceUID: e.exerciceUID,
                    recommendedSets: int.tryParse(
                          e.recommendedSets.state.text ?? '0',
                        ) ??
                        0,
                    recommendedReps: int.tryParse(
                          e.recommendedReps.state.text ?? '0',
                        ) ??
                        0,
                  ).toJson();
                }).toList(),
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
    );
  }

  Padding deleteButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: ElevatedButton(
        onPressed: () => Navigation.pushPopup(
          widget: DeleteWorkoutPopup(widget: widget),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
        child: const Text('Delete Workout'),
      ),
    );
  }
}

class DeleteWorkoutPopup extends StatelessWidget {
  const DeleteWorkoutPopup({
    super.key,
    required this.widget,
  });

  final AdminWorkoutAddScreen widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
    );
  }
}
