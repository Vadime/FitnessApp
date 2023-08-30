import 'dart:typed_data';

import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/src/course.dart';
import 'package:fitnessapp/models_ui/course_ui.dart';
import 'package:fitnessapp/pages/admin_course_delete_popup.dart';
import 'package:fitnessapp/pages/admin_home_screen.dart';
import 'package:fitnessapp/widgets/upload_file.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AdminCourseAddScreen extends StatefulWidget {
  final CourseUI? entry;
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

  Uint8List? imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = widget.entry?.image;

    nameBloc = TextFieldController.name(text: widget.entry?.course.name ?? '');
    descriptionBloc = TextFieldController(
      'Description',
      text: widget.entry?.course.description ?? '',
    );
    selectedDate = widget.entry?.course.date ?? DateTime.now();
  }

  Widget saveCourseButton() => Expanded(
        child: ElevatedButtonWidget(
          'Save Course',
          onPressed: () async {
            if (!nameBloc.isValid()) {
              Toast.info(
                nameBloc.calcErrorText!,
                context: context,
              );
              return;
            }
            if (!descriptionBloc.isValid()) {
              Toast.info(
                descriptionBloc.calcErrorText!,
                context: context,
              );
              return;
            }

            if (imageFile == null) {
              Toast.info(
                'Please select an image',
                context: context,
              );
              return;
            }
            // generate id, for storage and firestore
            String id;
            if (widget.entry?.course == null) {
              id = CourseRepository.genId();
            } else {
              id = widget.entry!.course.uid;
            }

            try {
              var course = Course(
                uid: id,
                name: nameBloc.text,
                description: descriptionBloc.text,
                date: selectedDate,
                userUIDS: widget.entry?.course.userUIDS ?? [],
                imageURL: await CourseRepository.uploadCourseImage(
                  id,
                  imageFile!,
                ),
              );
              await CourseRepository.uploadCourse(course);
              return Navigation.flush(
                widget: const AdminHomeScreen(initialIndex: 0),
              );
            } catch (e) {
              Toast.info(
                'Error saving course: $e',
                context: context,
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
            if (widget.entry?.course != null) deleteCourseButton(),
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
