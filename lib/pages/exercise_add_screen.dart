import 'dart:typed_data';

import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/exercise_delete_popup.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:fitnessapp/widgets/upload_file.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ExerciseAddScreen extends StatefulWidget {
  final Exercise? exercise;
  final Uint8List? imageFile;
  final Future Function(Exercise newExercise) upload;
  final Future Function()? delete;
  const ExerciseAddScreen({
    this.exercise,
    this.imageFile,
    required this.upload,
    required this.delete,
    super.key,
  });

  @override
  State<ExerciseAddScreen> createState() => _ExerciseAddScreenState();
}

class _ExerciseAddScreenState extends State<ExerciseAddScreen> {
  late TextFieldController nameBloc;
  late TextFieldController descriptionBloc;

  late MultiSelectionController<ExerciseMuscles> musclesController;

  Uint8List? imageFile;

  double caloriesBurned = 0;

  @override
  void initState() {
    super.initState();
    imageFile = widget.imageFile;
    nameBloc = TextFieldController.name(
      text: widget.exercise?.name,
    );
    descriptionBloc = TextFieldController(
      'Beschreibung',
      text: widget.exercise?.description,
    );

    musclesController =
        MultiSelectionController(widget.exercise?.muscles ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Übung ${widget.exercise != null ? 'ändern' : 'speichern'}',
      primaryButton: ElevatedButtonWidget(
        'Übung speichern',
        onPressed: () async {
          if (!nameBloc.isValid()) return;
          if (!descriptionBloc.isValid()) return;

          if (musclesController.state.isEmpty) {
            return ToastController().show(
              'Bitte wähle mindestens eine Muskelgruppe aus',
            );
          }

          if (imageFile == null) {
            return ToastController().show('Bitte wähle ein Bild aus');
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
            caloriesBurned: caloriesBurned,
          );

          try {
            await widget.upload(exercise);

            Navigation.flush(
              widget: const HomeScreen(initialIndex: 2),
            );
          } catch (e) {
            ToastController().show(e);
            return;
          }
        },
      ),
      actions: [
        if (widget.exercise != null)
          IconButtonWidget(
            Icons.delete_rounded,
            onPressed: () {
              // delete exercise
              Navigation.pushPopup(
                widget: ExerciseDeletePopup(
                  exercise: widget.exercise,
                  delete: widget.delete!,
                ),
              );
            },
          ),
      ],
      body: ScrollViewWidget(
        maxInnerWidth: 600,
        children: [
          UploadFile(
            imageFile: imageFile,
            onChanged: (file) {
              imageFile = file;
            },
          ),
          const SizedBox(height: 20),
          CardWidget(
            children: [
              TextFieldWidget(
                controller: nameBloc,
              ),
              TextFieldWidget(
                controller: descriptionBloc,
              ),
            ],
          ),
          const SizedBox(height: 20),
          MultiSelectionButton(
            controller: musclesController,
            buttons: [
              for (var type in ExerciseMuscles.values)
                ButtonData(type.str, type),
            ],
          ),
          const SizedBox(height: 20),
          CardWidget(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  const TextWidget(
                    'Kalorienverbrauch',
                  ),
                  const Expanded(
                    child: SizedBox(width: 20),
                  ),
                  TextWidget(
                    '$caloriesBurned kcal',
                  ),
                ],
              ),
              Slider(
                min: 0,
                max: 1000,
                divisions: 50,
                value: caloriesBurned,
                label: '${caloriesBurned.round()}',
                onChanged: (newValue) {
                  setState(() {
                    caloriesBurned = newValue;
                  });
                },
              ),
              Row(
                children: [
                  TextWidget(
                    '0 g',
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const Expanded(
                    child: SizedBox(width: 20),
                  ),
                  TextWidget(
                    '1000 g',
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
