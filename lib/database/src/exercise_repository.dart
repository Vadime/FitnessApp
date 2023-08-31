part of 'database.dart';

class ExerciseRepository {
  static firestore.CollectionReference<Map<String, dynamic>>
      get collectionReference =>
          firestore.FirebaseFirestore.instance.collection('exercises');

  static Future<List<Exercise>> getExercises() async {
    try {
      var doc = await firestore.FirebaseFirestore.instance
          .collection('exercises')
          .get();

      return doc.docs.map((e) => Exercise.fromJson(e.id, e.data())).toList();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<Exercise> getExercise(String uid) async {
    try {
      var doc = await firestore.FirebaseFirestore.instance
          .collection('exercises')
          .doc(uid)
          .get();
      if (doc.data() == null) throw 'Exercise not found';
      return Exercise.fromJson(doc.id, doc.data()!);
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> uploadExercise(Exercise exercise) async {
    await collectionReference.doc(exercise.uid).set(exercise.toJson());
  }

  static Future<String> uploadExerciseImage(
    String exerciseUID,
    Uint8List imageFile,
  ) async {
    try {
      return await (await storage.FirebaseStorage.instance
              .ref('exercises/$exerciseUID')
              .putData(imageFile))
          .ref
          .getDownloadURL();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<Uint8List?> getExerciseImage(Exercise exercise) async {
    if (exercise.imageURL == null) return null;
    try {
      return await storage.FirebaseStorage.instance
          .refFromURL(exercise.imageURL!)
          .getData();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  // Nimm alle Exercises aus einer Collection
  static Stream<List<Exercise>> get streamExercises {
    try {
      return firestore.FirebaseFirestore.instance
          .collection('exercises')
          .snapshots()
          .map(
            (event) => event.docs
                .map((e) => Exercise.fromJson(e.id, e.data()))
                .toList(),
          );
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> deleteExerciseImage(Exercise exercise) async {
    if (exercise.imageURL == null) return;
    try {
      await storage.FirebaseStorage.instance
          .refFromURL(exercise.imageURL!)
          .delete();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> deleteExercise(Exercise exercise) async {
    try {
      await collectionReference.doc(exercise.uid).delete();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }
}
