import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/user/home/exercise_info_screen.dart';
import 'package:flutter/material.dart';

class UserExercisesPage extends StatelessWidget {
  const UserExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: UserRepository.currentUserFavoriteExercises,
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (userSnapshot.data == null) {
          return const Center(
            child: Text(
              'Keine Daten gefunden\nSorry bro',
              textAlign: TextAlign.center,
            ),
          );
        }
        List<String> favoriteExerciseIDs = userSnapshot.data!;
        return StreamBuilder<List<Exercise>>(
          stream: ExerciseRepository.streamExercises,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            var exercises = snapshot.data!;

            // sort exercises with matching favoriteExerciseIDs first
            exercises.sort((a, b) {
              if (favoriteExerciseIDs.contains(a.uid) &&
                  !favoriteExerciseIDs.contains(b.uid)) {
                return -1;
              } else if (!favoriteExerciseIDs.contains(a.uid) &&
                  favoriteExerciseIDs.contains(b.uid)) {
                return 1;
              } else {
                return 0;
              }
            });

            // how many with matching favoriteExerciseIDs
            int matchingFavoriteExerciseIDs = 0;
            for (var exercise in exercises) {
              if (favoriteExerciseIDs.contains(exercise.uid)) {
                matchingFavoriteExerciseIDs++;
              } else {
                break;
              }
            }

            return ListView.builder(
              itemCount: exercises.length,
              padding: const EdgeInsets.all(10).addSafeArea(context),
              itemBuilder: (context, index) {
                File? imageFile;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (index == 0)
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Favorites',
                          style: context.textTheme.bodyMedium,
                        ),
                      ),
                    if (index == matchingFavoriteExerciseIDs)
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'All Exercises',
                          style: context.textTheme.bodyMedium,
                        ),
                      ),
                    StatefulBuilder(
                      builder: (context, setState) {
                        FirebaseStorage.instance
                            .refFromURL(exercises[index].imageURL!)
                            .getData()
                            .then(
                          (value) {
                            imageFile = File(
                              '${Directory.systemTemp.path}/${exercises[index].uid}',
                            );
                            imageFile!.writeAsBytesSync(value!.toList());
                            setState(() {});
                          },
                        );
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: imageFile == null
                                      ? Container(
                                          color: context.theme.highlightColor,
                                          width: 100,
                                        )
                                      : Image.file(
                                          imageFile!,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                ListTile(
                                  title: Text(exercises[index].name),
                                  subtitle: Text(exercises[index].description),
                                  onTap: () => Navigation.push(
                                    widget: ExerciseInfoScreen(
                                      exercise: exercises[index],
                                      imageFile: imageFile!,
                                      isFavorite: favoriteExerciseIDs
                                          .contains(exercises[index].uid),
                                    ),
                                  ),
                                ),
                              ],
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
      },
    );
  }
}
