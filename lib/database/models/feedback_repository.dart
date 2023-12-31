part of '../modules/database.dart';

class FeedbackRepository {
  static firestore.CollectionReference<Map<String, dynamic>>
      get collectionReference => Store.instance.collection('feedback');

  // Nimm alle Workouts aus einer Collection
  static Stream<List<MyFeedback>> get streamFeedback {
    try {
      return Store.instance.collection('feedback').snapshots().map(
            (event) => event.docs.map((e) {
              return MyFeedback.fromJson(e.data());
            }).toList(),
          );
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  // Nimm alle Workouts aus einer Collection
  static Future<List<MyFeedback>> get adminFeedbackAsFuture async {
    try {
      return (await Store.instance.collection('feedback').get())
          .docs
          .map(
            (e) => MyFeedback.fromJson(
              e.data(),
            ),
          )
          .toList();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> addFeedback(MyFeedback feedback) async {
    try {
      await collectionReference.add(feedback.toJson());
    } catch (e, s) {
      throw handleException(e, s);
    }
  }
}
