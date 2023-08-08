import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness_app/models/src/course.dart';
import 'package:fitness_app/utils/src/logging.dart';
import 'package:flutter/services.dart';

class CourseRepository {
  static Future<File?> getCourseImage(Course course) async {
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
}
