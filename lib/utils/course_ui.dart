import 'dart:typed_data';

import 'package:fitnessapp/models/src/course.dart';

class CourseUI {
  final Course course;
  final Uint8List? image;

  const CourseUI(this.course, this.image);
}
