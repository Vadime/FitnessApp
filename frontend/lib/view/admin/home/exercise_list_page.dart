import 'dart:io';

import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin/home/exercise_add_screen.dart';
import 'package:fitness_app/view/admin/home/exercise_image.dart';
import 'package:flutter/material.dart';

class AdminExercisesPage extends StatefulWidget {
  const AdminExercisesPage({super.key});

  @override
  State<AdminExercisesPage> createState() => _AdminExercisesPageState();
}

class _AdminExercisesPageState extends State<AdminExercisesPage> {
  List<File?> imageFiles = [];

  late Stream<List<Exercise>> exerciseStream;

  @override
  void initState() {
    super.initState();
    exerciseStream = ExerciseRepository.streamExercises;
    ExerciseRepository.getExercises().then(
      (exercises) {
        for (int i = 0; i < exercises.length; i++) {
          ExerciseRepository.getExerciseImage(exercises[i]).then(
            (value) => setState(() => imageFiles.insert(i, value)),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Exercise>>(
      stream: exerciseStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Exercise>? exercises = snapshot.data;

        if (exercises == null || exercises.isEmpty) {
          return const Center(child: Text('No exercises found'));
        }
        return ListView.builder(
          itemCount: exercises.length,
          padding: const EdgeInsets.all(10).addSafeArea(context),
          itemBuilder: (context, index) {
            Exercise exercise = exercises[index];

            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(exercise.name),
                trailing: ExerciseImage(imageFiles: imageFiles, index: index),
                subtitle: Text(
                  exercise.description,
                ),
                onTap: () => Navigation.push(
                  widget: AdminAddExercisesScreen(
                    exercise: exercise,
                    imageFile: imageFiles[index],
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
