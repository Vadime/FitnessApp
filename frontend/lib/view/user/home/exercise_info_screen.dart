import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/database/user_repository.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';

class ExerciseInfoScreen extends StatefulWidget {
  final Exercise exercise;
  final File imageFile;
  final bool isFavorite;
  const ExerciseInfoScreen({
    required this.exercise,
    required this.imageFile,
    required this.isFavorite,
    super.key,
  });

  @override
  State<ExerciseInfoScreen> createState() => _ExerciseInfoScreenState();
}

class _ExerciseInfoScreenState extends State<ExerciseInfoScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name),
        actions: [
          // add to favorites
          IconButton(
            onPressed: () async {
              // add or remove this exercise to favorites in firestore in user collection

              if (isFavorite) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(UserRepository.currentUserUID)
                    .update({
                  'favoriteExercises':
                      FieldValue.arrayRemove([widget.exercise.uid]),
                });
              } else {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(UserRepository.currentUserUID)
                    .set(
                  {
                    'favoriteExercises':
                        FieldValue.arrayUnion([widget.exercise.uid]),
                  },
                  SetOptions(merge: true),
                );
              }
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: Icon(
              !isFavorite
                  ? Icons.favorite_border_rounded
                  : Icons.favorite_rounded,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: context.theme.cardColor,
                image: DecorationImage(
                  image: FileImage(widget.imageFile),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                    TableRow(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Difficulty'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(widget.exercise.difficulty.strName),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
