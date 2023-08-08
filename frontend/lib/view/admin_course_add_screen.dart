import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness_app/models/src/course.dart';
import 'package:fitness_app/utils/src/file_picking.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin_course_delete_popup.dart';
import 'package:fitness_app/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AdminCourseAddScreen extends StatefulWidget {
  final Course? course;
  final File? imageFile;

  const AdminCourseAddScreen({
    this.course,
    this.imageFile,
    super.key,
  });

  @override
  State<AdminCourseAddScreen> createState() => _AdminCourseAddScreenState();
}

class _AdminCourseAddScreenState extends State<AdminCourseAddScreen> {
  late NameBloc nameBloc;
  late TextBloc descriptionBloc;
  late TextBloc dateBloc;

  File? imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = widget.imageFile;

    nameBloc = NameBloc(
      initialValue: widget.course?.name ?? '',
    );
    descriptionBloc = TextBloc(
      initialValue: widget.course?.description ?? '',
      hint: 'Description',
    );
    dateBloc = TextBloc(
      initialValue: widget.course?.date ?? '',
      hint: 'Date',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Course'),
        actions: [
          // delete button
          if (widget.course != null)
            IconButton(
              onPressed: () {
                // delete exercise
                Navigation.pushPopup(
                  widget: AdminCourseDeletePopup(
                    widget: widget,
                  ),
                );
              },
              icon: const Icon(
                Icons.delete_rounded,
                color: Colors.red,
              ),
            ),
          // add and update button
          IconButton(
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
              if (!dateBloc.isValid()) {
                return Messaging.show(
                  message: dateBloc.state.errorText!,
                );
              }

              if (imageFile == null) {
                return Messaging.show(
                  message: 'Please select an image',
                );
              }
              // generate id, for storage and firestore
              String id;
              if (widget.course == null) {
                id = FirebaseFirestore.instance.collection('courses').doc().id;
              } else {
                id = widget.course!.uid;
              }

              // create exercise
              var course = Course(
                uid: id,
                name: nameBloc.state.text!,
                description: descriptionBloc.state.text!,
                date: dateBloc.state.text!,
              );
              // Upload image
              course.imageURL = await (await FirebaseStorage.instance
                      .ref('courses/${course.uid}')
                      .putFile(imageFile!))
                  .ref
                  .getDownloadURL();

              await FirebaseFirestore.instance
                  .collection('courses')
                  .doc(course.uid)
                  .set(course.toJson())
                  .then((value) {
                Messaging.show(
                  message:
                      'Course ${widget.course == null ? 'added' : 'updated'}',
                );
                Navigation.flush(
                  widget: const HomeScreen(),
                );
              }).catchError(
                (e) {
                  Messaging.show(
                    message:
                        'Error ${widget.course == null ? 'adding' : 'updating'} course: $e',
                  );
                },
              );
            },
            icon: const Icon(
              Icons.save_rounded,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        children: [
          Container(
            alignment: Alignment.bottomRight,
            height: 200,
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                  const SizedBox(height: 10),
                  MyTextField(
                    bloc: dateBloc,
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
