import 'dart:io';

import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/exercise_image.dart';
import 'package:fitness_app/view/user_exercise_info_screen.dart';
import 'package:fitness_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class UserExerciseListPage extends StatefulWidget {
  const UserExerciseListPage({super.key});

  @override
  State<UserExerciseListPage> createState() => _UserExerciseListPageState();
}

class _UserExerciseListPageState extends State<UserExerciseListPage> {
  Map<Tupel<Exercise, File?>, bool>? exercises;

  @override
  void initState() {
    super.initState();
    loadExercises();
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
    return ListView(
      padding: const EdgeInsets.all(20).addSafeArea(context),
      children: [
        const Text('Favorites'),
        if (exercises!.entries.where((element) => element.value).isEmpty)
          const SizedBox(
            height: 100,
            child: MyErrorWidget(error: 'You have no favorite exercises'),
          ),
        const SizedBox(height: 10),
        for (var entry in exercises!.entries.where((element) => element.value))
          exerciseListTile(entry),
        const SizedBox(height: 10),
        const Text('Other'),
        if (exercises!.entries.where((element) => !element.value).isEmpty)
          const SizedBox(
            height: 100,
            child: MyErrorWidget(error: 'No other exercises found'),
          ),
        const SizedBox(height: 10),
        for (var entry in exercises!.entries.where((element) => !element.value))
          exerciseListTile(entry),
      ],
    );
  }

  loadExercises() async {
    var favoriteUIDS =
        await UserRepository.currentUserFavoriteExercisesAsFuture;
    var exerciseList = await ExerciseRepository.getExercises();

    // sortieren damit favoriten oben sind und gleichmäßig geladen werden
    exerciseList.sort(
      (a, b) => (favoriteUIDS.contains(a.uid))
          ? favoriteUIDS.contains(b.uid)
              ? 0
              : -1
          : favoriteUIDS.contains(b.uid)
              ? 1
              : 0,
    );

    for (int i = 0; i < exerciseList.length; i++) {
      var image = await ExerciseRepository.getExerciseImage(exerciseList[i]);
      if (!mounted) return;
      (exercises ??= {}).putIfAbsent(
        Tupel(exerciseList[i], image),
        () => favoriteUIDS.contains(exerciseList[i].uid),
      );
      if (mounted) setState(() {});
    }
  }

  Widget exerciseListTile(MapEntry<Tupel<Exercise, File?>, bool> entry) =>
      MyListTile(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
        title: entry.key.t1.name,
        trailing: ExerciseImage(
          image: entry.key.t2,
        ),
        subtitle: entry.key.t1.description,
        onTap: () => Navigation.push(
          widget: UserExerciseInfoScreen(
            exercise: entry.key.t1,
            imageFile: entry.key.t2,
            isFavorite: entry.value,
          ),
        ),
      );
}
