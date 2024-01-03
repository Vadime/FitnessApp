import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/pages/user_exercise_add_screen.dart';
import 'package:fitnessapp/pages/user_exercise_info_screen.dart';
import 'package:fitnessapp/utils/exercise_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserExerciseListPage extends StatefulWidget {
  const UserExerciseListPage({super.key});

  @override
  State<UserExerciseListPage> createState() => _UserExerciseListPageState();
}

class _UserExerciseListPageState extends State<UserExerciseListPage>
    with AutomaticKeepAliveClientMixin {
  List<ExerciseUI>? favoriteExercises;
  List<ExerciseUI>? filteredFavoriteExercises;
  List<ExerciseUI>? yourExercises;
  List<ExerciseUI>? filteredYourExercises;
  List<ExerciseUI>? otherExercises;
  List<ExerciseUI>? filteredOtherExercises;

  TextFieldController searchController =
      TextFieldController('Suche nach Übungen');

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      //filter exercises
      filterExercises(searchController);
      setState(() {});
    });
    loadExercises();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollViewWidget(
      maxInnerWidth: 600,
      children: [
        // search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: TextFieldWidget(
            controller: searchController,
          ),
        ),
        // Favoriten (Angezeigt wenn es welche gibt)
        const TextWidget(
          'Lieblingsübungen',
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
        if (filteredFavoriteExercises == null)
          const SizedBox(
            height: 100,
            child: LoadingWidget(),
          )
        else if (filteredFavoriteExercises!.isEmpty)
          const SizedBox(
            height: 100,
            child: FailWidget(
              'Keine Lieblingsübungen',
            ),
          )
        else
          for (var entry in filteredFavoriteExercises!)
            exerciseListTile(entry, true, false),

        // Eigene Übungen (Angezeigt wenn es welche gibt)
        const TextWidget(
          'Deine Übungen',
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
        if (filteredYourExercises == null)
          const SizedBox(
            height: 100,
            child: LoadingWidget(),
          )
        else if (filteredYourExercises!.isEmpty)
          const SizedBox(
            height: 100,
            child: FailWidget(
              'Noch keine Übungen erstellt',
            ),
          )
        else
          for (var entry in filteredYourExercises!)
            exerciseListTile(entry, false, true),

        // Übungen vom Administrator (Angezeigt wenn es welche gibt)
        const TextWidget(
          'Andere Übungen',
          margin: EdgeInsets.symmetric(vertical: 10),
        ),
        if (filteredOtherExercises == null)
          const SizedBox(
            height: 100,
            child: LoadingWidget(),
          )
        else if (filteredOtherExercises!.isEmpty)
          const SizedBox(
            height: 100,
            child: FailWidget(
              'Noch keine Übungen erstellt',
            ),
          )
        else
          for (var entry in filteredOtherExercises!)
            exerciseListTile(entry, false, false),
      ],
    );
  }

  void filterExercises(searchController) {
    // Get the search query from the searchController
    String searchQuery = searchController.text.toLowerCase();

    // Filter favorite exercises
    filteredFavoriteExercises = favoriteExercises?.where((exercise) {
      return exercise.exercise.name.toLowerCase().contains(searchQuery);
    }).toList();

    // Filter your exercises
    filteredYourExercises = yourExercises?.where((exercise) {
      return exercise.exercise.name.toLowerCase().contains(searchQuery);
    }).toList();

    // Filter other exercises
    filteredOtherExercises = otherExercises?.where((exercise) {
      return exercise.exercise.name.toLowerCase().contains(searchQuery);
    }).toList();

    setState(() {});
  }

  loadExercises() async {
    var yourExerciseList =
        await UserRepository.currentUserCustomExercisesAsFuture;
    yourExercises ??= [];
    filteredYourExercises ??= [];
    for (int i = 0; i < yourExerciseList.length; i++) {
      var image =
          await ExerciseRepository.getExerciseImages(yourExerciseList[i]);
      yourExercises!.add(ExerciseUI(yourExerciseList[i], image));
      filteredYourExercises!.add(ExerciseUI(yourExerciseList[i], image));
      setState(() {});
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
    filteredFavoriteExercises ??= [];
    otherExercises ??= [];
    filteredOtherExercises ??= [];
    for (int i = 0; i < otherExerciseList.length; i++) {
      var image =
          await ExerciseRepository.getExerciseImages(otherExerciseList[i]);

      bool isFavorite = favoriteUIDS.contains(otherExerciseList[i].uid);
      if (isFavorite) {
        favoriteExercises!.add(ExerciseUI(otherExerciseList[i], image));
        filteredFavoriteExercises!.add(ExerciseUI(otherExerciseList[i], image));
      } else {
        otherExercises!.add(ExerciseUI(otherExerciseList[i], image));
        filteredOtherExercises!.add(ExerciseUI(otherExerciseList[i], image));
      }

      setState(() {});
    }
    setState(() {});
  }

  Widget exerciseListTile(ExerciseUI entry, bool isFavorite, bool editable) =>
      ListTileWidget(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        padding: const EdgeInsets.all(10),
        contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        subtitleOverflow: TextOverflow.ellipsis,
        title: entry.exercise.name,
        trailing: entry.images == null
            ? null
            : ImageWidget(
                MemoryImage(entry.images!.first),
                height: 50,
                width: 50,
                margin: const EdgeInsets.all(10),
              ),
        subtitle: entry.exercise.description,
        onTap: () => Navigation.push(
          widget: (editable)
              ? UserExerciseAddScreen(
                  exercise: entry.exercise,
                  imageFiles: entry.images,
                )
              : UserExerciseInfoScreen(
                  exercise: entry.exercise,
                  imageFile: entry.images?.first,
                  isFavorite: isFavorite,
                ),
        ),
      );
}
