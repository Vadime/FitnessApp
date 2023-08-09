part of 'database.dart';

class FeedbackRepository {
  static firestore.CollectionReference<Map<String, dynamic>>
      get collectionReference =>
          firestore.FirebaseFirestore.instance.collection('feedback');

  // Nimm alle Workouts aus einer Collection
  static Stream<List<MyFeedback>> get streamFeedback =>
      firestore.FirebaseFirestore.instance
          .collection('feedback')
          .snapshots()
          .map(
            (event) => event.docs.map((e) {
              return MyFeedback.fromJson(e.data());
            }).toList(),
          );

  // Nimm alle Workouts aus einer Collection
  static Future<List<MyFeedback>> get adminFeedbackAsFuture async =>
      (await firestore.FirebaseFirestore.instance.collection('feedback').get())
          .docs
          .map(
            (e) => MyFeedback.fromJson(
              e.data(),
            ),
          )
          .toList();

  static Future<void> addFeedback(MyFeedback feedback) async {
    await collectionReference.add(feedback.toJson());
  }
}
