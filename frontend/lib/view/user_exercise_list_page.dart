import 'dart:io';

import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/exercise_image.dart';
import 'package:fitness_app/view/user_exercise_info_screen.dart';
import 'package:flutter/material.dart';

class UserExerciseListPage extends StatefulWidget {
  const UserExerciseListPage({super.key});

  @override
  State<UserExerciseListPage> createState() => _UserExerciseListPageState();
}

class _UserExerciseListPageState extends State<UserExerciseListPage> {
  List<File?> imageFiles = [];

  late Stream<List<Exercise>> exerciseStream;
  late Stream<List<String>> favoriteStream;

  @override
  void initState() {
    super.initState();
    exerciseStream = ExerciseRepository.streamExercises;
    favoriteStream = UserRepository.currentUserFavoriteExercises;
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
    return StreamBuilder<List<String>>(
      stream: favoriteStream,
      builder: (context, favoritesSnapshot) {
        if (!favoritesSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return StreamBuilder<List<Exercise>>(
          stream: exerciseStream,
          builder: (context, exercisesSnapshot) {
            if (!exercisesSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            List<Exercise>? allExercises = exercisesSnapshot.data;
            List<String>? favoriteUIDs = favoritesSnapshot.data;

            if (allExercises == null || allExercises.isEmpty) {
              return Center(
                child: Text(
                  'No exercises found',
                  style: context.textTheme.labelSmall,
                ),
              );
            }

            List<Exercise> favoriteExercises = [];
            List<File?> favoriteImages = [];
            List<Exercise> otherExercises = [];
            List<File?> otherImages = [];

            for (int i = 0; i < allExercises.length; i++) {
              Exercise e = allExercises[i];
              bool contains = false;
              if (favoriteUIDs != null) {
                for (String s in favoriteUIDs) {
                  if (s == e.uid) {
                    favoriteExercises.add(e);
                    favoriteImages.add(imageFiles.elementAtOrNull(i));
                    contains = true;
                    break;
                  }
                }
              }
              if (!contains) otherExercises.add(e);
              if (!contains) otherImages.add(imageFiles.elementAtOrNull(i));
            }

            return ListView(
              children: [
                const SafeArea(
                  bottom: false,
                  child: SizedBox(),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text('Favorites'),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: favoriteExercises.length,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    Exercise exercise = favoriteExercises[index];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 10, 10, 20),
                        title: Text(exercise.name),
                        trailing: ExerciseImage(
                          imageFiles: favoriteImages,
                          index: index,
                        ),
                        subtitle: Text(
                          exercise.description,
                        ),
                        onTap: () => Navigation.push(
                          widget: UserExerciseInfoScreen(
                            exercise: exercise,
                            imageFile: favoriteImages[index]!,
                            isFavorite: true,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (favoriteExercises.isEmpty)
                  SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        'No favorites yet',
                        style: context.textTheme.labelSmall,
                      ),
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Text('Other'),
                ),
                if (otherExercises.isEmpty)
                  SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        'No other exercises',
                        style: context.textTheme.labelSmall,
                      ),
                    ),
                  ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: otherExercises.length,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    Exercise exercise = otherExercises[index];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 10, 10, 20),
                        title: Text(exercise.name),
                        trailing: ExerciseImage(
                          imageFiles: otherImages,
                          index: index,
                        ),
                        subtitle: Text(
                          exercise.description,
                        ),
                        onTap: () => Navigation.push(
                          widget: UserExerciseInfoScreen(
                            exercise: exercise,
                            imageFile: otherImages.elementAtOrNull(index),
                            isFavorite: false,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
