import 'dart:io';

import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/admin_exercise_delete_popup.dart';
import 'package:fitnessapp/pages/home_screen.dart';
import 'package:fitnessapp/widgets/upload_file.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AdminExerciseAddScreen extends StatefulWidget {
  final Exercise? exercise;
  final File? imageFile;
  const AdminExerciseAddScreen({this.exercise, this.imageFile, super.key});

  @override
  State<AdminExerciseAddScreen> createState() => _AdminExerciseAddScreenState();
}

class _AdminExerciseAddScreenState extends State<AdminExerciseAddScreen> {
  late TextFieldController nameBloc;
  late TextFieldController descriptionBloc;

  late MultiSelectionController<ExerciseMuscles> musclesController;

  File? imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = widget.imageFile;
    nameBloc = TextFieldController.name(
      text: widget.exercise?.name,
    );
    descriptionBloc = TextFieldController(
      'Description',
      text: widget.exercise?.description,
    );

    musclesController =
        MultiSelectionController(widget.exercise?.muscles ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        '${widget.exercise != null ? 'Update' : 'Add'} Exercise',
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
                child: IconButtonWidget(
                  Icons.delete_rounded,
                  onPressed: () {
                    // delete exercise
                    Navigation.pushPopup(
                      widget: AdminExerciseDeletePopup(
                        widget: widget,
                      ),
                    );
                  },
                ),
              ),
            // add and update button
            Expanded(
              child: ElevatedButtonWidget(
                'Save Exercise',
                onPressed: () async {
                  if (!nameBloc.isValid()) {
                    return Messaging.info(
                      message: nameBloc.errorText!,
                    );
                  }
                  if (!descriptionBloc.isValid()) {
                    return Messaging.info(
                      message: descriptionBloc.errorText!,
                    );
                  }

                  if (musclesController.state.isEmpty) {
                    return Messaging.info(
                      message: 'Please select at least one muscle',
                    );
                  }

                  if (imageFile == null) {
                    return Messaging.info(
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
                    name: nameBloc.text,
                    description: descriptionBloc.text,
                    muscles: musclesController.state,
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
                      Messaging.info(
                        message:
                            'Error ${widget.exercise == null ? 'adding' : 'updating'} exercise: $e',
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 30),
          ],
        ),
      ),
      body: ListView(
        children: [
          UploadFile(
            imageFile: imageFile,
            onChanged: (file) {
              imageFile = file;
            },
          ),
          CardWidget(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            children: [
              TextFieldWidget(
                controller: nameBloc,
              ),
              TextFieldWidget(
                controller: descriptionBloc,
              ),
            ],
          ),
          MultiSelectionButton(
            margin: const EdgeInsets.all(20),
            controller: musclesController,
            buttons: [
              for (var type in ExerciseMuscles.values)
                ButtonData(type.strName, type),
            ],
          ),
        ],
      ),
    );
  }
}
