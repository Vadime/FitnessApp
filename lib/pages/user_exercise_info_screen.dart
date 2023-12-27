import 'dart:typed_data';

import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserExerciseInfoScreen extends StatefulWidget {
  final Exercise exercise;
  final Uint8List? imageFile;
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
    return ScaffoldWidget(
      title: widget.exercise.name,
      actions: [
        IconButtonWidget(
          !isFavorite ? Icons.favorite_border_rounded : Icons.favorite_rounded,
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
        ),
      ],
      body: ScrollViewWidget(
        maxInnerWidth: 600,
        children: [
          ImageWidget(
            widget.imageFile == null ? null : MemoryImage(widget.imageFile!),
            height: 200,
          ),
          const SizedBox(height: 20),
          CardWidget.single(
            padding: const EdgeInsets.all(20),
            child: TextWidget(widget.exercise.description),
          ),
          const SizedBox(height: 20),
          TableWidget(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            rows: [
              TableRowWidget(
                cells: [
                  'Muskelgruppen',
                  widget.exercise.muscles.map((e) => e.str).join(', '),
                ],
              ),
              TableRowWidget(
                cells: [
                  'Kalorien',
                  '${widget.exercise.caloriesBurned.toStringAsFixed(0)} kcal',
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
