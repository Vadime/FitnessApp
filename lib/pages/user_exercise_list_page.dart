import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models_ui/exercise_ui.dart';
import 'package:fitnessapp/pages/user_exercise_add_screen.dart';
import 'package:fitnessapp/pages/user_exercise_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserExerciseListPage extends StatefulWidget {
  const UserExerciseListPage({super.key});

  @override
  State<UserExerciseListPage> createState() => _UserExerciseListPageState();
}

class _UserExerciseListPageState extends State<UserExerciseListPage> {
  List<ExerciseUI>? favoriteExercises;
  List<ExerciseUI>? yourExercises;
  List<ExerciseUI>? otherExercises;

  @override
  void initState() {
    super.initState();
    loadExercises();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20).add(context.safeArea),
      children: [
        // Favoriten (Angezeigt wenn es welche gibt)
        const TextWidget(
          'Favorite Exercises',
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
        if (favoriteExercises == null)
          const SizedBox(
            height: 100,
            child: LoadingWidget(),
          )
        else if (favoriteExercises!.isEmpty)
          const SizedBox(
            height: 100,
            child: FailWidget(
              'No favorites yet',
            ),
          )
        else
          for (var entry in favoriteExercises!)
            exerciseListTile(entry, true, false),

        // Eigene Übungen (Angezeigt wenn es welche gibt)
        const TextWidget(
          'Your Exercises',
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
        if (yourExercises == null)
          const SizedBox(
            height: 100,
            child: LoadingWidget(),
          )
        else if (yourExercises!.isEmpty)
          const SizedBox(
            height: 100,
            child: FailWidget(
              'No extra Exercises added',
            ),
          )
        else
          for (var entry in yourExercises!)
            exerciseListTile(entry, false, true),

        // Übungen vom Administrator (Angezeigt wenn es welche gibt)
        const TextWidget(
          'Other Exercises',
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
        if (otherExercises == null)
          const SizedBox(
            height: 100,
            child: LoadingWidget(),
          )
        else if (otherExercises!.isEmpty)
          const SizedBox(
            height: 100,
            child: FailWidget(
              'No extra Exercises added',
            ),
          )
        else
          for (var entry in otherExercises!)
            exerciseListTile(entry, false, false),
      ],
    );
  }

  loadExercises() async {
    var yourExerciseList =
        await UserRepository.currentUserCustomExercisesAsFuture;
    yourExercises ??= [];
    for (int i = 0; i < yourExerciseList.length; i++) {
      var image =
          await ExerciseRepository.getExerciseImage(yourExerciseList[i]);
      if (!mounted) return;
      yourExercises!.add(ExerciseUI(yourExerciseList[i], image));
      if (mounted) setState(() {});
    }

    var favoriteUIDS =
        await UserRepository.currentUserFavoriteExercisesAsFuture;
    var otherExerciseList = await ExerciseRepository.getExercises();

    // sortieren damit favoriten oben sind und gleichmäßig geladen werden
    otherExerciseList.sort(
      (a, b) => (favoriteUIDS.contains(a.uid))
          ? favoriteUIDS.contains(b.uid)
              ? 0
              : -1
          : favoriteUIDS.contains(b.uid)
              ? 1
              : 0,
    );
    favoriteExercises ??= [];
    otherExercises ??= [];
    for (int i = 0; i < otherExerciseList.length; i++) {
      var image =
          await ExerciseRepository.getExerciseImage(otherExerciseList[i]);
      if (!mounted) return;
      bool isFavorite = favoriteUIDS.contains(otherExerciseList[i].uid);
      if (isFavorite) {
        favoriteExercises!.add(ExerciseUI(otherExerciseList[i], image));
      } else {
        otherExercises!.add(ExerciseUI(otherExerciseList[i], image));
      }
      if (mounted) setState(() {});
    }
  }

  Widget exerciseListTile(ExerciseUI entry, bool isFavorite, bool editable) =>
      ListTileWidget(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        padding: const EdgeInsets.all(10),
        contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        subtitleOverflow: TextOverflow.ellipsis,
        title: entry.exercise.name,
        trailing: entry.image == null
            ? null
            : ImageWidget(
                MemoryImage(entry.image!),
                height: 50,
                width: 50,
                margin: const EdgeInsets.all(10),
              ),
        subtitle: entry.exercise.description,
        onTap: () => Navigation.push(
          widget: (editable)
              ? UserExerciseAddScreen(
                  exercise: entry.exercise,
                  imageFile: entry.image,
                )
              : UserExerciseInfoScreen(
                  exercise: entry.exercise,
                  imageFile: entry.image,
                  isFavorite: isFavorite,
                ),
        ),
      );
}
