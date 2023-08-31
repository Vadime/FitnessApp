import 'dart:typed_data';

import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/admin_exercise_delete_popup.dart';
import 'package:fitnessapp/pages/admin_home_screen.dart';
import 'package:fitnessapp/widgets/upload_file.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AdminExerciseAddScreen extends StatefulWidget {
  final Exercise? exercise;
  final Uint8List? imageFile;
  const AdminExerciseAddScreen({this.exercise, this.imageFile, super.key});

  @override
  State<AdminExerciseAddScreen> createState() => _AdminExerciseAddScreenState();
}

class _AdminExerciseAddScreenState extends State<AdminExerciseAddScreen> {
  late TextFieldController nameBloc;
  late TextFieldController descriptionBloc;

  late MultiSelectionController<ExerciseMuscles> musclesController;

  Uint8List? imageFile;

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
                    return Toast.info(
                      nameBloc.errorText!,
                      context: context,
                    );
                  }
                  if (!descriptionBloc.isValid()) {
                    return Toast.info(
                      descriptionBloc.errorText!,
                      context: context,
                    );
                  }

                  if (musclesController.state.isEmpty) {
                    return Toast.info(
                      'Please select at least one muscle',
                      context: context,
                    );
                  }

                  if (imageFile == null) {
                    return Toast.info(
                      'Please select an image',
                      context: context,
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
                      widget: const AdminHomeScreen(initialIndex: 2),
                    );
                  }).catchError(
                    (e) {
                      Toast.info(
                        'Error ${widget.exercise == null ? 'adding' : 'updating'} exercise: $e',
                        context: context,
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
                ButtonData(type.str, type),
            ],
          ),
        ],
      ),
    );
  }
}
