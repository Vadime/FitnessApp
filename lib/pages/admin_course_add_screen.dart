import 'dart:typed_data';

import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/src/course.dart';
import 'package:fitnessapp/pages/admin_course_delete_popup.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:fitnessapp/utils/course_ui.dart';
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
      'Beschreibung',
      text: widget.entry?.course.description ?? '',
    );
    selectedDate = widget.entry?.course.date ?? DateTime.now();
  }

  Widget saveCourseButton() => Expanded(
        child: ElevatedButtonWidget(
          'Save Course',
          onPressed: () async {
            if (!nameBloc.isValid()) return;
            if (!descriptionBloc.isValid()) return;

            if (imageFile == null) {
              ToastController().show('Please select an image');
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
                widget: const HomeScreen(initialIndex: 0),
              );
            } catch (e) {
              ToastController().show(e);
              return;
            }
          },
        ),
      );

  Widget deleteCourseButton() => Padding(
        padding: const EdgeInsets.only(right: 20),
        child: IconButtonWidget(
          Icons.delete_rounded,
          onPressed: () {
            Navigation.pushPopup(
              widget: AdminCourseDeletePopup(
                widget: widget,
              ),
            );
            return;
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Add Course',
      actions: [
        if (widget.entry?.course != null) deleteCourseButton(),
        saveCourseButton(),
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
                const TextWidget('Datum'),
                const Spacer(),
                TextButtonWidget(
                  selectedDate.ddMMYYYY,
                  onPressed: () {
                    Navigation.pushDatePicker(
                      first: selectedDate.subtract(const Duration(days: 100)),
                      last: DateTime.now().add(const Duration(days: 100)),
                      initial: selectedDate,
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
        ],
      ),
    );
  }
}
