import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/src/logging.dart';

class ExerciseRepository {
  static firestore.CollectionReference<Map<String, dynamic>>
      get collectionReference =>
          firestore.FirebaseFirestore.instance.collection('exercises');

  static Future<List<Exercise>> getExercises() async {
    var doc = await firestore.FirebaseFirestore.instance
        .collection('exercises')
        .get();
    return doc.docs.map((e) => Exercise.fromJson(e.id, e.data())).toList();
  }

  static Future<void> uploadExercise(Exercise exercise) async {
    await collectionReference.doc(exercise.uid).set(exercise.toJson());
  }

  static Future<String> uploadExerciseImage(
    Exercise exercise,
    File imageFile,
  ) async {
    return await (await storage.FirebaseStorage.instance
            .ref('exercises/${exercise.uid}')
            .putFile(imageFile))
        .ref
        .getDownloadURL();
  }

  static Future<File?> getExerciseImage(Exercise exercise) async {
    if (exercise.imageURL == null) return null;
    try {
      Uint8List? data = await storage.FirebaseStorage.instance
          .refFromURL(exercise.imageURL!)
          .getData();
      if (data == null) return null;
      File image = File(
        '${Directory.systemTemp.path}/${exercise.uid}',
      )..writeAsBytesSync(data.toList());
      return image;
    } catch (e, s) {
      Logging.error(e.toString(), s);
      return null;
    }
  }

  // Nimm alle Exercises aus einer Collection
  static Stream<List<Exercise>> get streamExercises => firestore
      .FirebaseFirestore.instance
      .collection('exercises')
      .snapshots()
      .map(
        (event) =>
            event.docs.map((e) => Exercise.fromJson(e.id, e.data())).toList(),
      );
}
