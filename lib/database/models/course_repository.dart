part of '../modules/database.dart';

class CourseRepository {
  static Future<Uint8List?> getCourseImage(Course course) async {
    if (course.imageURL == null) return null;
    try {
      return await Storage.instance.refFromURL(course.imageURL!).getData();
    } catch (e, s) {
      handleException(e, s);
      return null;
    }
  }

  static Future<List<Course>> get coursesAsFuture async =>
      (await Store.instance.collection('courses').get())
          .docs
          .map((e) => Course.fromJson(e.id, e.data()))
          .toList();

  static Future<void> enterCourse(Course? course, User? user) async {
    if (course == null || user == null) return;
    try {
      await Store.instance.collection('courses').doc(course.uid).update(
        {
          'userUIDS': firestore.FieldValue.arrayUnion([user.uid]),
        },
      );
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> leaveCourse(Course? course, User? user) async {
    if (course == null || user == null) return;
    try {
      await Store.instance.collection('courses').doc(course.uid).update(
        {
          'userUIDS': firestore.FieldValue.arrayRemove([user.uid]),
        },
      );
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static String genId() => Store.instance.collection('courses').doc().id;

  static Future<void> uploadCourse(Course course) async {
    try {
      await Store.instance
          .collection('courses')
          .doc(course.uid)
          .set(course.toJson());
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<String?> uploadCourseImage(
    String courseUID,
    Uint8List imageFile,
  ) async {
    try {
      return await (await Storage.instance
              .ref('courses/$courseUID')
              .putData(imageFile))
          .ref
          .getDownloadURL();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> deleteCourseImage(Course course) async {
    if (course.imageURL == null) return;
    try {
      await Storage.instance.refFromURL(course.imageURL!).delete();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> deleteCourse(Course course) async {
    try {
      await Store.instance.collection('courses').doc(course.uid).delete();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }
}
