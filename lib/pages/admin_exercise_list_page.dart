import 'dart:io';

import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/admin_exercise_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AdminExerciseListPage extends StatefulWidget {
  const AdminExerciseListPage({super.key});

  @override
  State<AdminExerciseListPage> createState() => _AdminExerciseListPageState();
}

class _AdminExerciseListPageState extends State<AdminExerciseListPage> {
  List<Tupel<Exercise, File?>>? exercises;

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  loadExercises() async {
    var exerciseList = await ExerciseRepository.getExercises();
    for (Exercise exercise in exerciseList) {
      if (!mounted) return;
      var image = await ExerciseRepository.getExerciseImage(exercise);
      (exercises ??= []).add(Tupel(exercise, image));
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (exercises == null) {
      return const LoadingWidget();
    }

    if (exercises!.isEmpty) {
      return const FailWidget(
        'No exercises found',
      );
    }
    return ListView.builder(
      itemCount: exercises!.length,
      padding: const EdgeInsets.all(20).add(context.safeArea),
      itemBuilder: (context, index) {
        Tupel<Exercise, File?> exercise = exercises![index];

        return ListTileWidget(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          title: exercise.t1.name,
          trailing: exercise.t2 == null
              ? null
              : ImageWidget(
                  FileImage(exercise.t2!),
                  height: 40,
                  width: 40,
                ),
          subtitle: exercise.t1.description,
          onTap: () => Navigation.push(
            widget: AdminExerciseAddScreen(
              exercise: exercise.t1,
              imageFile: exercise.t2,
            ),
          ),
        );
      },
    );
  }
}
