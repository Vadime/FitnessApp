import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/src/file_picking.dart';
import 'package:fitness_app/utils/src/logging.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/both/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AdminAddExercisesScreen extends StatefulWidget {
  final Exercise? exercise;
  final File? imageFile;
  const AdminAddExercisesScreen({this.exercise, this.imageFile, super.key});

  @override
  State<AdminAddExercisesScreen> createState() =>
      _AdminAddExercisesScreenState();
}

class _AdminAddExercisesScreenState extends State<AdminAddExercisesScreen> {
  late NameBloc nameBloc;
  late TextBloc descriptionBloc;

  late Set<ExerciseMuscles> selectedMuscles;
  late Set<ExerciseDifficulty> selectedDifficulty;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = widget.imageFile;
    nameBloc = NameBloc(
      initialValue: widget.exercise?.name,
    );
    descriptionBloc = TextBloc(
      initialValue: widget.exercise?.description,
      hint: 'Description',
    );

    selectedMuscles = widget.exercise?.muscles.toSet() ?? {};
    selectedDifficulty = widget.exercise?.difficulty != null
        ? {widget.exercise!.difficulty}
        : {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('${widget.exercise != null ? 'Update' : 'Add'} Exercise'),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SafeArea(
                    bottom: false,
                    child: SizedBox(),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    height: 200,
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: context.theme.cardColor,
                      image: imageFile != null
                          ? DecorationImage(
                              image: FileImage(imageFile!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:
                            context.theme.cardColor.withOpacity(0.8),
                      ),
                      onPressed: () async {
                        var file = await FilePicking.pickImage();
                        if (file == null) {
                          Messaging.show(
                            message: 'Error picking image',
                          );
                          return;
                        }
                        setState(() {
                          imageFile = file;
                        });
                        //
                        Messaging.show(message: 'Upload Image');
                      },
                      child: Text(
                        'Upload Image',
                        style: context.textTheme.labelMedium!
                            .copyWith(color: context.theme.primaryColor),
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MyTextField(
                            bloc: nameBloc,
                          ),
                          const SizedBox(height: 10),
                          MyTextField(
                            bloc: descriptionBloc,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      'Muscles Worked',
                      style: context.textTheme.bodyMedium,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: SegmentedButton<ExerciseMuscles>(
                        multiSelectionEnabled: true,
                        emptySelectionAllowed: true,
                        segments: [
                          for (var type in ExerciseMuscles.values)
                            ButtonSegment(
                              label: Text(type.strName),
                              value: type,
                            ),
                        ],
                        selected: selectedMuscles,
                        onSelectionChanged: (p0) =>
                            setState(() => selectedMuscles = p0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      'Difficulty',
                      style: context.textTheme.bodyMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: SegmentedButton<ExerciseDifficulty>(
                      emptySelectionAllowed: true,
                      selectedIcon: Icon(
                        Icons.check_rounded,
                        color: context.theme.primaryColor,
                      ),
                      segments: [
                        for (var type in ExerciseDifficulty.values)
                          ButtonSegment(
                            label: Text(type.strName),
                            value: type,
                          ),
                      ],
                      selected: selectedDifficulty,
                      onSelectionChanged: (p0) =>
                          setState(() => selectedDifficulty = p0),
                    ),
                  ),
                  const SafeArea(
                    top: false,
                    child: SizedBox(
                      height: 56,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // delete button
                  if (widget.exercise != null)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: ElevatedButton(
                          onPressed: () {
                            // delete exercise
                            Navigation.pushPopup(
                              widget: DeleteExercisePopup(
                                widget: widget,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Delete Exercise'),
                        ),
                      ),
                    ),
                  // add and update button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!nameBloc.isValid()) {
                            return Messaging.show(
                              message: nameBloc.state.errorText!,
                            );
                          }
                          if (!descriptionBloc.isValid()) {
                            return Messaging.show(
                              message: descriptionBloc.state.errorText!,
                            );
                          }

                          if (selectedMuscles.isEmpty) {
                            return Messaging.show(
                              message: 'Please select at least one muscle',
                            );
                          }
                          if (selectedDifficulty.isEmpty) {
                            return Messaging.show(
                              message: 'Please select a difficulty',
                            );
                          }
                          if (imageFile == null) {
                            return Messaging.show(
                              message: 'Please select an image',
                            );
                          }
                          // generate id, for storage and firestore
                          String id;
                          if (widget.exercise == null) {
                            id =
                                ExerciseRepository.collectionReference.doc().id;
                          } else {
                            id = widget.exercise!.uid;
                          }

                          // create exercise
                          var exercise = Exercise(
                            uid: id,
                            name: nameBloc.state.text!,
                            description: descriptionBloc.state.text!,
                            muscles: selectedMuscles.toList(),
                            difficulty: selectedDifficulty.first,
                          );
                          // Upload image
                          exercise.imageURL =
                              await ExerciseRepository.uploadExerciseImage(
                            exercise,
                            imageFile!,
                          );

                          await ExerciseRepository.uploadExercise(exercise)
                              .then((value) {
                            Messaging.show(
                              message:
                                  'Exercise ${widget.exercise == null ? 'added' : 'updated'}',
                            );
                            Navigation.flush(
                              widget: const HomeScreen(initialIndex: 1),
                            );
                          }).catchError(
                            (e) {
                              Messaging.show(
                                message:
                                    'Error ${widget.exercise == null ? 'adding' : 'updating'} exercise: $e',
                              );
                            },
                          );
                        },
                        child: Text(
                          '${widget.exercise == null ? 'Add' : 'Update'} Exercise',
                        ),
                      ),
                    ),
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

class DeleteExercisePopup extends StatelessWidget {
  const DeleteExercisePopup({
    super.key,
    required this.widget,
  });

  final AdminAddExercisesScreen widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Delete Exercise',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            const Text(
              'Are you sure you want to delete this exercise?',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                if (widget.exercise != null) {
                  // delete image from storage
                  try {
                    await FirebaseStorage.instance
                        .refFromURL(
                          widget.exercise!.imageURL!,
                        )
                        .delete();
                    // delete exercise from database
                    await FirebaseFirestore.instance
                        .collection('exercises')
                        .doc(widget.exercise!.uid)
                        .delete();
                  } catch (e, s) {
                    Logging.error(e, s);
                    Messaging.show(
                      message: 'Error deleting exercise: $e',
                    );
                    Navigation.pop();
                    return;
                  }
                }
                Navigation.flush(
                  widget: const HomeScreen(initialIndex: 1),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
