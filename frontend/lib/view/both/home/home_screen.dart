import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness_app/bloc/home/home_bloc.dart';
import 'package:fitness_app/bloc/home/home_item.dart';
import 'package:fitness_app/database/user_repository.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/src/file_picking.dart';
import 'package:fitness_app/utils/src/logging.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/admin/home/exercise_add_screen.dart';
import 'package:fitness_app/view/admin/home/exercise_image.dart';
import 'package:fitness_app/view/admin/home/exercise_list_page.dart';
import 'package:fitness_app/view/admin/home/profile_page.dart';
import 'package:fitness_app/view/admin/home/workout_add_screen.dart';
import 'package:fitness_app/view/admin/home/workout_list_page.dart';
import 'package:fitness_app/view/both/footer.dart';
import 'package:fitness_app/view/both/home/profile_edit_screen.dart';
import 'package:fitness_app/view/user/home/exercise_list_page.dart';
import 'package:fitness_app/view/user/home/profile_page.dart';
import 'package:fitness_app/view/user/home/workout_add_screen.dart';
import 'package:fitness_app/view/user/home/workout_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  final int initialIndex;
  const HomeScreen({this.initialIndex = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        Map<UserRole, List<HomeItem>> homeItems = {
          UserRole.admin: [
            HomeItem(
              title: 'Courses',
              icon: Icons.home_rounded,
              page: const AdminCourseListPage(),
              action: IconButton(
                onPressed: () =>
                    Navigation.push(widget: const AdminCourseAddScreen()),
                icon: const Icon(Icons.add_rounded),
                tooltip: 'Add Course',
              ),
            ),
            HomeItem(
              title: 'Workouts',
              icon: Icons.sports_gymnastics_rounded,
              page: const AdminWorkoutListPage(),
              action: IconButton(
                onPressed: () =>
                    Navigation.push(widget: const AdminWorkoutAddScreen()),
                icon: const Icon(Icons.add_rounded),
                tooltip: 'Add Workout',
              ),
            ),
            HomeItem(
              title: 'Exercises',
              icon: Icons.list_rounded,
              page: const AdminExercisesPage(),
              action: IconButton(
                onPressed: () =>
                    Navigation.push(widget: const AdminAddExercisesScreen()),
                icon: const Icon(Icons.add_rounded),
                tooltip: 'Add Exercise',
              ),
            ),
            HomeItem(
              title: 'Profile',
              icon: Icons.person_rounded,
              page: const AdminProfilePage(),
              action: IconButton(
                onPressed: () =>
                    Navigation.push(widget: const EditProfileScreen()),
                icon: const Icon(Icons.edit_rounded),
                tooltip: 'Edit Profile',
              ),
            ),
          ],
          UserRole.user: [
            const HomeItem(
              title: 'Courses',
              icon: Icons.home_rounded,
              page: UserCourseListPage(),
            ),
            HomeItem(
              title: 'Workouts',
              icon: Icons.sports_gymnastics_rounded,
              page: const UserWorkoutsPage(),
              action: IconButton(
                onPressed: () =>
                    Navigation.push(widget: const UserWorkoutAddScreen()),
                icon: const Icon(Icons.add_rounded),
                tooltip: 'Add Workout',
              ),
            ),
            const HomeItem(
              title: 'Exercises',
              icon: Icons.list_rounded,
              page: UserExercisesPage(),
            ),
            HomeItem(
              title: 'Profile',
              icon: Icons.person_rounded,
              page: const UserProfilePage(),
              action: IconButton(
                onPressed: () =>
                    Navigation.push(widget: const EditProfileScreen()),
                icon: const Icon(Icons.edit_rounded),
                tooltip: 'Edit Profile',
              ),
            ),
          ],
        };
        return HomeBloc(
          initialIndex: initialIndex,
          homePages: homeItems[UserRepository.currentUserRole]!,
        );
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Navigation.pushPopup(
                  widget: const HomeFooter(),
                ),
              ),
              title: Text(
                state.title,
              ),
              actions: [
                state.action ?? const SizedBox(),
              ],
            ),
            body: state.page,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.index,
              onTap: (value) => context.read<HomeBloc>().add(
                    HomePageChangedEvent(
                      index: value,
                    ),
                  ),
              items: context
                  .read<HomeBloc>()
                  .homePages
                  .map(
                    (e) => e.bottomNavigationBarItem,
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}

class Course extends Equatable {
  final String uid;
  final String name;
  final String description;
  String? imageURL;

  final String date;

  Course({
    required this.uid,
    required this.name,
    required this.description,
    required this.date,
    this.imageURL,
  });

  // to json
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'date': date,
        'imageURL': imageURL,
      };

  // from json
  factory Course.fromJson(String uid, Map<String, dynamic> json) => Course(
        uid: uid,
        name: json['name'],
        description: json['description'],
        date: json['date'],
        imageURL: json['imageURL'],
      );

  @override
  List<Object?> get props => [uid, name, description, date, imageURL];
}

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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              const Spacer(),
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
              const Spacer(),
              Row(
                children: [
                  // delete button
                  if (widget.course != null)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: ElevatedButton(
                          onPressed: () {
                            // delete exercise
                            Navigation.pushPopup(
                              widget: DeleteCoursePopup(
                                widget: widget,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Delete Course'),
                        ),
                      ),
                    ),
                  // add and update button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: ElevatedButton(
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
                            id = FirebaseFirestore.instance
                                .collection('courses')
                                .doc()
                                .id;
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
                          course.imageURL = await (await FirebaseStorage
                                  .instance
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
                        child: Text(
                          '${widget.course == null ? 'Add' : 'Update'} Course',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteCoursePopup extends StatelessWidget {
  const DeleteCoursePopup({
    super.key,
    required this.widget,
  });

  final AdminCourseAddScreen widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Delete Course',
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            const Text(
              'Are you sure you want to delete this course?',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                if (widget.course != null) {
                  // delete image from storage
                  try {
                    await FirebaseStorage.instance
                        .refFromURL(
                          widget.course!.imageURL ?? '',
                        )
                        .delete()
                        .catchError((_) {});
                    // delete exercise from database
                    await FirebaseFirestore.instance
                        .collection('courses')
                        .doc(widget.course!.uid)
                        .delete();
                  } catch (e, s) {
                    Logging.error(e, s);
                    Messaging.show(
                      message: 'Error deleting course: $e',
                    );
                    Navigation.pop();
                    return;
                  }
                }
                Navigation.flush(
                  widget: const HomeScreen(),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminCourseListPage extends StatefulWidget {
  const AdminCourseListPage({super.key});

  @override
  State<AdminCourseListPage> createState() => _AdminCourseListPageState();
}

Future<File?> getCourseImage(Course course) async {
  if (course.imageURL == null) return null;
  try {
    Uint8List? data =
        await FirebaseStorage.instance.refFromURL(course.imageURL!).getData();
    if (data == null) return null;
    File image = File(
      '${Directory.systemTemp.path}/${course.uid}',
    )..writeAsBytesSync(data.toList());
    return image;
  } catch (e, s) {
    Logging.error(e.toString(), s);
    return null;
  }
}

class _AdminCourseListPageState extends State<AdminCourseListPage> {
  List<Course>? courses;
  List<File?> imageFiles = [];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('courses').get().then(
      (value) {
        courses =
            value.docs.map((e) => Course.fromJson(e.id, e.data())).toList();
        setState(() {});
        for (int i = 0; i < courses!.length; i++) {
          getCourseImage(courses![i]).then(
            (value) => setState(() => imageFiles.insert(i, value)),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (courses == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (courses!.isEmpty) {
      return const Center(
        child: Text('No courses found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10).addSafeArea(context),
      itemCount: courses!.length,
      itemBuilder: (context, index) {
        final e = courses![index];
        return Card(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListTile(
                title: Text(e.name),
                subtitle: Text(e.description),
                trailing: ExerciseImage(imageFiles: imageFiles, index: index),
                onTap: () {
                  Navigation.push(
                    widget: AdminCourseAddScreen(
                      course: e,
                      imageFile: imageFiles.elementAtOrNull(index),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Text(
                  e.date,
                  style: context.textTheme.labelSmall,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class UserCourseListPage extends StatefulWidget {
  const UserCourseListPage({super.key});

  @override
  State<UserCourseListPage> createState() => _UserCourseListPageState();
}

class _UserCourseListPageState extends State<UserCourseListPage> {
  List<Course>? courses;
  List<File?> imageFiles = [];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('courses').get().then(
      (value) {
        courses =
            value.docs.map((e) => Course.fromJson(e.id, e.data())).toList();
        setState(() {});
        for (int i = 0; i < courses!.length; i++) {
          getCourseImage(courses![i]).then(
            (value) => setState(() => imageFiles.insert(i, value)),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (courses == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (courses!.isEmpty) {
      return const Center(
        child: Text('No courses found'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10).addSafeArea(context),
      itemCount: courses!.length,
      itemBuilder: (context, index) {
        final e = courses![index];
        return Card(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListTile(
                title: Text(e.name),
                subtitle: Text(e.description),
                trailing: ExerciseImage(imageFiles: imageFiles, index: index),
                // onTap: () {
                //   Navigation.push(
                //     widget: AdminCourseAddScreen(
                //       course: e,
                //       imageFile: imageFiles.elementAtOrNull(index),
                //     ),
                //   );
                // },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Text(
                  e.date,
                  style: context.textTheme.labelSmall,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
