part of '../modules/database.dart';

class ExerciseRepository {
  static firestore.CollectionReference<Map<String, dynamic>>
      get collectionReference => Store.instance.collection('exercises');

  static Future<List<Exercise>> getExercises() async {
    try {
      var doc = await collectionReference.get();
      return doc.docs.map((e) => Exercise.fromJson(e.id, e.data())).toList();
    } catch (e, s) {
      handleException(e, s);
      return [];
    }
  }

  static Future<Exercise?> getExercise(String uid) async {
    try {
      var doc = await collectionReference.doc(uid).get();
      if (doc.data() == null) return null;
      return Exercise.fromJson(doc.id, doc.data()!);
    } catch (e, s) {
      handleException(e, s);
      return null;
    }
  }

  static Future<void> uploadExercise(Exercise exercise) async {
    await collectionReference.doc(exercise.uid).set(exercise.toJson());
  }

  static Future<List<String>> uploadExerciseImages(
    String exerciseUID,
    List<Uint8List> imageFile,
  ) async {
    try {
      List<String> urls = [];
      for (int i = 0; i < imageFile.length; i++) {
        var image = imageFile[i];
        urls.add(
          await (await Storage.instance
                  .ref('exercises/$exerciseUID/$i')
                  .putData(image))
              .ref
              .getDownloadURL(),
        );
      }
      return urls;
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<List<Uint8List>?> getExerciseImages(Exercise? exercise) async {
    if (exercise?.imageURLs == null) return null;
    List<Uint8List> images = [];
    for (var url in exercise!.imageURLs!) {
      try {
        var data = await Storage.instance.refFromURL(url).getData();
        if (data == null) continue;
        images.add(data);
      } catch (e, s) {
        handleException(e, s);
        continue;
      }
    }
    return images;
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

  static Future<void> deleteExerciseImages(Exercise exercise) async {
    if (exercise.imageURLs == null) return;
    try {
      for (var url in exercise.imageURLs ?? []) {
        await Storage.instance.refFromURL(url).delete();
      }
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
