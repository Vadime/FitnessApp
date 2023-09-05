import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/admin_exercise_add_screen.dart';
import 'package:fitnessapp/utils/exercise_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AdminExerciseListPage extends StatefulWidget {
  const AdminExerciseListPage({super.key});

  @override
  State<AdminExerciseListPage> createState() => _AdminExerciseListPageState();
}

class _AdminExerciseListPageState extends State<AdminExerciseListPage>
    with AutomaticKeepAliveClientMixin {
  List<ExerciseUI>? exercises;

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
      (exercises ??= []).add(ExerciseUI(exercise, image));
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
        ExerciseUI exercise = exercises![index];

        return ListTileWidget(
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          padding: const EdgeInsets.all(10),
          contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          subtitleOverflow: TextOverflow.ellipsis,
          title: exercise.exercise.name,
          trailing: exercise.image == null
              ? null
              : ImageWidget(
                  MemoryImage(exercise.image!),
                  height: 50,
                  width: 50,
                  margin: const EdgeInsets.all(10),
                ),
          subtitle: exercise.exercise.description,
          onTap: () => Navigation.push(
            widget: AdminExerciseAddScreen(
              exercise: exercise.exercise,
              imageFile: exercise.image,
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
