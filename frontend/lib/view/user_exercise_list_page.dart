import 'dart:io';

import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/view/exercise_image.dart';
import 'package:fitnessapp/view/user_exercise_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

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
      return const LoadingWidget();
    }
    if (exercises!.isEmpty) {
      return const FailWidget(
        'No exercises found',
      );
    }
    return ListView(
      padding: const EdgeInsets.all(20).add(context.safeArea),
      children: [
        const Text('Favorites'),
        if (exercises!.entries.where((element) => element.value).isEmpty)
          const SizedBox(
            height: 100,
            child: FailWidget('You have no favorite exercises'),
          ),
        const SizedBox(height: 10),
        for (var entry in exercises!.entries.where((element) => element.value))
          exerciseListTile(entry),
        const SizedBox(height: 10),
        const Text('Other'),
        if (exercises!.entries.where((element) => !element.value).isEmpty)
          const SizedBox(
            height: 100,
            child: FailWidget('No other exercises found'),
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
      ListTileWidget(
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
