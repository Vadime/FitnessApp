part of 'database.dart';

class CourseRepository {
  static Future<File?> getCourseImage(Course course) async {
    if (course.imageURL == null) return null;
    try {
      Uint8List? data = await storage.FirebaseStorage.instance
          .refFromURL(course.imageURL!)
          .getData();
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

  static Future<List<Course>> get coursesAsFuture async =>
      (await firestore.FirebaseFirestore.instance.collection('courses').get())
          .docs
          .map((e) => Course.fromJson(e.id, e.data()))
          .toList();

  static Future<void> enterCourse(Course? course, User? user) async {
    if (course == null || user == null) return;
    await firestore.FirebaseFirestore.instance
        .collection('courses')
        .doc(course.uid)
        .update(
      {
        'userUIDS': firestore.FieldValue.arrayUnion([user.uid])
      },
    );
  }

  static Future<void> leaveCourse(Course? course, User? user) async {
    if (course == null || user == null) return;
    await firestore.FirebaseFirestore.instance
        .collection('courses')
        .doc(course.uid)
        .update(
      {
        'userUIDS': firestore.FieldValue.arrayRemove([user.uid])
      },
    );
  }

  static String genId() =>
      firestore.FirebaseFirestore.instance.collection('courses').doc().id;

  static Future<void> uploadCourse(Course course) async {
    await firestore.FirebaseFirestore.instance
        .collection('courses')
        .doc(course.uid)
        .set(course.toJson());
  }

  static Future<String?> uploadCourseImage(
    String courseUID,
    File imageFile,
  ) async =>
      await (await storage.FirebaseStorage.instance
              .ref('courses/$courseUID')
              .putFile(imageFile))
          .ref
          .getDownloadURL();

  static Future<void> deleteCourseImage(Course course) async {
    await storage.FirebaseStorage.instance
        .refFromURL(
          course.imageURL ?? '',
        )
        .delete()
        .catchError((_) {});
  }

  static Future<void> deleteCourse(Course course) async {
    // delete exercise from database
    await firestore.FirebaseFirestore.instance
        .collection('courses')
        .doc(course.uid)
        .delete();
  }
}
