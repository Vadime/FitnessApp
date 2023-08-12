import 'dart:io';

import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/src/file_picking.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin_exercise_delete_popup.dart';
import 'package:fitness_app/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/widgets/widgets.dart';

class AdminExerciseAddScreen extends StatefulWidget {
  final Exercise? exercise;
  final File? imageFile;
  const AdminExerciseAddScreen({this.exercise, this.imageFile, super.key});

  @override
  State<AdminExerciseAddScreen> createState() => _AdminExerciseAddScreenState();
}

class _AdminExerciseAddScreenState extends State<AdminExerciseAddScreen> {
  late NameBloc nameBloc;
  late TextBloc descriptionBloc;

  late Set<ExerciseMuscles> selectedMuscles;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: MyAppBar(
        title: '${widget.exercise != null ? 'Update' : 'Add'} Exercise',
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Row(
          children: [
            const SizedBox(width: 30),
            // delete button
            if (widget.exercise != null)
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () {
                    // delete exercise
                    Navigation.pushPopup(
                      widget: AdminExerciseDeletePopup(
                        widget: widget,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.delete_rounded,
                  ),
                ),
              ),
            // add and update button
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  if (!nameBloc.isValid()) {
                    return Navigation.pushMessage(
                      message: nameBloc.state.errorText!,
                    );
                  }
                  if (!descriptionBloc.isValid()) {
                    return Navigation.pushMessage(
                      message: descriptionBloc.state.errorText!,
                    );
                  }

                  if (selectedMuscles.isEmpty) {
                    return Navigation.pushMessage(
                      message: 'Please select at least one muscle',
                    );
                  }

                  if (imageFile == null) {
                    return Navigation.pushMessage(
                      message: 'Please select an image',
                    );
                  }
                  // generate id, for storage and firestore
                  String id;
                  if (widget.exercise == null) {
                    id = ExerciseRepository.collectionReference.doc().id;
                  } else {
                    id = widget.exercise!.uid;
                  }

                  // create exercise
                  var exercise = Exercise(
                    uid: id,
                    name: nameBloc.state.text!,
                    description: descriptionBloc.state.text!,
                    muscles: selectedMuscles.toList(),
                    imageURL: await ExerciseRepository.uploadExerciseImage(
                      id,
                      imageFile!,
                    ),
                  );

                  await ExerciseRepository.uploadExercise(exercise)
                      .then((value) {
                    Navigation.flush(
                      widget: const HomeScreen(initialIndex: 2),
                    );
                  }).catchError(
                    (e) {
                      Navigation.pushMessage(
                        message:
                            'Error ${widget.exercise == null ? 'adding' : 'updating'} exercise: $e',
                      );
                    },
                  );
                },
                child: const Text(
                  'Save Exercise',
                ),
              ),
            ),
            const SizedBox(width: 30),
          ],
        ),
      ),
      body: ListView(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            height: 200,
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                backgroundColor: context.theme.cardColor.withOpacity(0.8),
              ),
              onPressed: () async {
                var file = await FilePicking.pickImage();
                if (file == null) {
                  Navigation.pushMessage(
                    message: 'Error picking image',
                  );
                  return;
                }
                setState(() {
                  imageFile = file;
                });
              },
              child: Text(
                'Upload Image',
                style: context.textTheme.labelMedium!
                    .copyWith(color: context.theme.primaryColor),
              ),
            ),
          ),
          MyCard(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text(
              'Muscles Worked',
              style: context.textTheme.bodyMedium,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
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
        ],
      ),
    );
  }
}
