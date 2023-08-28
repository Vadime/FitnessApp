import 'dart:io';

import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/src/course.dart';
import 'package:fitnessapp/pages/admin_course_delete_popup.dart';
import 'package:fitnessapp/pages/home_screen.dart';
import 'package:fitnessapp/widgets/upload_file.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AdminCourseAddScreen extends StatefulWidget {
  final MapEntry<Course, File?>? entry;
  const AdminCourseAddScreen({
    this.entry,
    super.key,
  });

  @override
  State<AdminCourseAddScreen> createState() => _AdminCourseAddScreenState();
}

class _AdminCourseAddScreenState extends State<AdminCourseAddScreen> {
  late TextFieldController nameBloc;
  late TextFieldController descriptionBloc;

  late DateTime selectedDate;

  File? imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = widget.entry?.value;

    nameBloc = TextFieldController.name(text: widget.entry?.key.name ?? '');
    descriptionBloc = TextFieldController(
      'Description',
      text: widget.entry?.key.description ?? '',
    );
    selectedDate = widget.entry?.key.date ?? DateTime.now();
  }

  Widget saveCourseButton() => Expanded(
        child: ElevatedButtonWidget(
          'Save Course',
          onPressed: () async {
            if (!nameBloc.isValid()) {
              Messaging.info(
                message: nameBloc.calcErrorText!,
              );
              return;
            }
            if (!descriptionBloc.isValid()) {
              Messaging.info(
                message: descriptionBloc.calcErrorText!,
              );
              return;
            }

            if (imageFile == null) {
              Messaging.info(
                message: 'Please select an image',
              );
              return;
            }
            // generate id, for storage and firestore
            String id;
            if (widget.entry?.key == null) {
              id = CourseRepository.genId();
            } else {
              id = widget.entry!.key.uid;
            }

            try {
              var course = Course(
                uid: id,
                name: nameBloc.text,
                description: descriptionBloc.text,
                date: selectedDate,
                userUIDS: widget.entry?.key.userUIDS ?? [],
                imageURL: await CourseRepository.uploadCourseImage(
                  id,
                  imageFile!,
                ),
              );
              await CourseRepository.uploadCourse(course);
              return Navigation.flush(
                widget: const HomeScreen(initialIndex: 0),
              );
            } catch (e) {
              Messaging.info(
                message: 'Error saving course: $e',
              );
              return;
            }
          },
        ),
      );

  Widget deleteCourseButton() => Padding(
        padding: const EdgeInsets.only(right: 20),
        child: IconButtonWidget(
          Icons.delete_rounded,
          onPressed: () => Navigation.pushPopup(
            widget: AdminCourseDeletePopup(
              widget: widget,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: const AppBarWidget(
        'Add Course',
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Row(
          children: [
            const SizedBox(width: 30),
            if (widget.entry?.key != null) deleteCourseButton(),
            saveCourseButton(),
            const SizedBox(width: 30),
          ],
        ),
      ),
      body: ListView(
        children: [
          const SafeArea(
            bottom: false,
            child: SizedBox(),
          ),
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
                maxLines: 2,
                minLines: 1,
                expands: false,
              ),
            ],
          ),
          CardWidget.single(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text('Datum'),
                const Spacer(),
                TextButtonWidget(
                  selectedDate.toDate(),
                  onPressed: () {
                    Navigation.pushDatePicker(
                      firstDate:
                          selectedDate.subtract(const Duration(days: 100)),
                      lastDate: DateTime.now().add(const Duration(days: 100)),
                      initialDate: selectedDate,
                      onChanged: (date) {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SafeArea(
            top: false,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
