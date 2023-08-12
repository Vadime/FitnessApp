import 'dart:io';

import 'package:fitness_app/database/database.dart';
import 'package:fitness_app/models/src/course.dart';
import 'package:fitness_app/utils/src/file_picking.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin_course_delete_popup.dart';
import 'package:fitness_app/view/home_screen.dart';
import 'package:fitness_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

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
  late NameBloc nameBloc;
  late TextBloc descriptionBloc;
  late TextBloc dateBloc;

  File? imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = widget.entry?.value;

    nameBloc = NameBloc(
      initialValue: widget.entry?.key.name ?? '',
    );
    descriptionBloc = TextBloc(
      initialValue: widget.entry?.key.description ?? '',
      hint: 'Description',
    );
    dateBloc = TextBloc(
      initialValue: widget.entry?.key.date ?? '',
      hint: 'Date',
    );
  }

  Widget saveCourseButton() => Expanded(
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
            if (!dateBloc.isValid()) {
              return Navigation.pushMessage(
                message: dateBloc.state.errorText!,
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
              var course = Course(
                uid: id,
                name: nameBloc.state.text!,
                description: descriptionBloc.state.text!,
                date: dateBloc.state.text!,
                userUIDS: widget.entry?.key.userUIDS ?? [],
                imageURL: await CourseRepository.uploadCourseImage(
                  id,
                  imageFile!,
                ),
              );
              await CourseRepository.uploadCourse(course);

              Navigation.flush(widget: const HomeScreen(initialIndex: 0));
            } catch (e) {
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
      appBar: const MyAppBar(
        title: 'Add Course',
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
          MyCard(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
          const SafeArea(
            top: false,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
