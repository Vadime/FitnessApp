import 'dart:typed_data';

import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/user_exercise_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserExerciseListPage extends StatefulWidget {
  const UserExerciseListPage({super.key});

  @override
  State<UserExerciseListPage> createState() => _UserExerciseListPageState();
}

class _UserExerciseListPageState extends State<UserExerciseListPage> {
  Map<Tupel<Exercise, Uint8List?>, bool>? exercises;

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

  Widget exerciseListTile(MapEntry<Tupel<Exercise, Uint8List?>, bool> entry) =>
      ListTileWidget(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        padding: const EdgeInsets.all(10),
        contentPadding: const EdgeInsets.all(10),
        subtitleOverflow: TextOverflow.ellipsis,
        title: entry.key.t1.name,
        trailing: entry.key.t2 == null
            ? null
            : ImageWidget(
                MemoryImage(entry.key.t2!),
                height: 50,
                width: 50,
                margin: const EdgeInsets.all(10),
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
