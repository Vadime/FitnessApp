part of '../modules/database.dart';

class ExerciseRepository {
  static firestore.CollectionReference<Map<String, dynamic>>
      get collectionReference => Store.instance.collection('exercises');

  static Future<List<Exercise>> getExercises() async {
    try {
      var doc = await collectionReference.get();

      return doc.docs.map((e) => Exercise.fromJson(e.id, e.data())).toList();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<Exercise> getExercise(String uid) async {
    try {
      var doc = await collectionReference.doc(uid).get();
      if (doc.data() == null) throw 'Exercise not found';
      return Exercise.fromJson(doc.id, doc.data()!);
    } catch (e, s) {
      handleException(e, s);
      return Exercise.emptyExercise;
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
      return await (await Storage.instance
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
      return await Storage.instance.refFromURL(exercise.imageURL!).getData();
    } catch (e, s) {
      handleException(e, s);
      return null;
    }
  }

  // Nimm alle Exercises aus einer Collection
  static Stream<List<Exercise>> get streamExercises {
    try {
      return collectionReference.snapshots().map(
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
      await Storage.instance.refFromURL(exercise.imageURL!).delete();
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
