import 'dart:io';

import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin/home/exercise_add_screen.dart';
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Exercise>>(
      stream: exerciseStream,
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
          padding: const EdgeInsets.all(10).addSafeArea(context),
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(10),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: ExerciseImage(imageFiles: imageFiles, index: index),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    title: Text(exercises[index].name),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(right: 90),
                      child: Text(exercises[index].description),
                    ),
                    onTap: () => Navigation.push(
                      widget: AdminAddExercisesScreen(
                        exercise: exercises[index],
                        imageFile: imageFiles[index],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class ExerciseImage extends StatelessWidget {
  const ExerciseImage({
    super.key,
    required this.imageFiles,
    required this.index,
  });

  final List<File?> imageFiles;
  final int index;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(
        right: Radius.circular(10),
      ),
      child: imageFiles.elementAtOrNull(index) == null
          ? Container(
              color: context.theme.highlightColor,
              width: 100,
            )
          : Image.file(
              imageFiles[index]!,
              width: 100,
              fit: BoxFit.cover,
            ),
    );
  }
}
