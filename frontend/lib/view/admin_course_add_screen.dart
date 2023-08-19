import 'dart:io';

import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/src/course.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/view/admin_course_delete_popup.dart';
import 'package:fitnessapp/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
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

    nameBloc = TextFieldController.name();
    descriptionBloc = TextFieldController(
      'Description',
      text: widget.entry?.key.description ?? '',
    );
    selectedDate = widget.entry?.key.date ?? DateTime.now();
  }

  Widget saveCourseButton() => Expanded(
        child: ElevatedButton(
          onPressed: () async {
            if (!nameBloc.isValid()) {
              return Navigation.pushMessage(
                message: nameBloc.calcErrorText!,
              );
            }
            if (!descriptionBloc.isValid()) {
              return Navigation.pushMessage(
                message: descriptionBloc.calcErrorText!,
              );
            }

            if (imageFile == null) {
              return Navigation.pushMessage(
                message: 'Please select an image',
              );
            }
            // generate id, for storage and firestore
            String id;
            if (widget.entry?.key == null) {
              id = CourseRepository.genId();
            } else {
              id = widget.entry!.key.uid;
            }

            try {
              Navigation.disableInput();
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
              Navigation.enableInput();
              Navigation.flush(widget: const HomeScreen(initialIndex: 0));
            } catch (e) {
              Navigation.enableInput();
              Navigation.pushMessage(
                message: 'Error saving course: $e',
              );
            }
          },
          child: const Text(
            'Save Course',
          ),
        ),
      );

  Widget deleteCourseButton() => Padding(
        padding: const EdgeInsets.only(right: 20),
        child: IconButton(
          onPressed: () => Navigation.pushPopup(
            widget: AdminCourseDeletePopup(
              widget: widget,
            ),
          ),
          icon: const Icon(
            Icons.delete_rounded,
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
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        children: [
          const SafeArea(
            bottom: false,
            child: SizedBox(),
          ),
          Container(
            alignment: Alignment.bottomRight,
            height: 200,
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
          const SizedBox(height: 20),
          CardWidget(
            children: [
              TextFieldWidget(
                nameBloc,
              ),
              TextFieldWidget(
                descriptionBloc,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ScrollDatePicker(
                minimumDate: DateTime.now().subtract(const Duration(days: 1)),
                maximumDate: DateTime.now().add(const Duration(days: 365)),
                options: DatePickerOptions(
                  backgroundColor: context.theme.cardColor,
                ),
                indicator: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: context.theme.scaffoldBackgroundColor.withOpacity(0),
                  ),
                ),
                selectedDate: selectedDate,
                onDateTimeChanged: (date) => setState(() {
                  selectedDate = date;
                }),
              ),
            ),
          ),
          const SafeArea(
            top: false,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
