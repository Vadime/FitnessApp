import 'dart:io';

import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/widgets/widgets.dart';

class UserExerciseInfoScreen extends StatefulWidget {
  final Exercise exercise;
  final File? imageFile;
  final bool isFavorite;
  const UserExerciseInfoScreen({
    required this.exercise,
    required this.imageFile,
    required this.isFavorite,
    super.key,
  });

  @override
  State<UserExerciseInfoScreen> createState() => _UserExerciseInfoScreenState();
}

class _UserExerciseInfoScreenState extends State<UserExerciseInfoScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppBar(
        title: widget.exercise.name,
        actions: [
          // add to favorites
          IconButton(
            onPressed: () async {
              // add or remove this exercise to favorites in firestore in user collection

              if (isFavorite) {
                await UserRepository.removeFavoriteExercise(
                  widget.exercise.uid,
                );
              } else {
                await UserRepository.addFavoriteExercise(
                  widget.exercise.uid,
                );
              }
              setState(() {
                isFavorite = !isFavorite;
              });
              Navigation.flush(
                widget: const HomeScreen(
                  initialIndex: 2,
                ),
              );
            },
            icon: Icon(
              !isFavorite
                  ? Icons.favorite_border_rounded
                  : Icons.favorite_rounded,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20).addSafeArea(context),
        children: [
          SizedBox(height: context.topInset),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: context.theme.cardColor,
              image: widget.imageFile == null
                  ? null
                  : DecorationImage(
                      image: FileImage(widget.imageFile!),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                children: [
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Description'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(widget.exercise.description),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Muscles'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          widget.exercise.muscles
                              .map((e) => e.strName)
                              .join(', '),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
