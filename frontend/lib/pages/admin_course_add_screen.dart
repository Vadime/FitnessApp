import 'dart:io';

import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/src/course.dart';
import 'package:fitnessapp/pages/admin_course_delete_popup.dart';
import 'package:fitnessapp/pages/home_screen.dart';
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
            Navigation.pushLoading();

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
              return Navigation.pushMessage(
                message: 'Error saving course: $e',
              );
            } finally {
              Navigation.pop();
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
                controller: nameBloc,
              ),
              TextFieldWidget(
                controller: descriptionBloc,
                maxLines: 2,
                minLines: 1,
                expands: false,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 20),
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
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 20),
            ],
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
