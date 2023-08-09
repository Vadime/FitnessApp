import 'dart:io';

import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin_exercise_add_screen.dart';
import 'package:fitness_app/view/exercise_image.dart';
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
      return const MyLoadingWidget();
    }

    if (exercises!.isEmpty) {
      return const MyErrorWidget(
        error: 'No exercises found',
      );
    }
    return ListView.builder(
      itemCount: exercises!.length,
      padding: const EdgeInsets.all(20).addSafeArea(context),
      itemBuilder: (context, index) {
        Tupel<Exercise, File?> exercise = exercises![index];

        return MyListTile(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          title: exercise.t1.name,
          trailing: ExerciseImage(image: exercise.t2),
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
