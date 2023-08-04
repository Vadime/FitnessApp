import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:fitness_app/models/models.dart';

class WorkoutRepository {
  static firestore.CollectionReference<Map<String, dynamic>>
      get collectionReference =>
          firestore.FirebaseFirestore.instance.collection('workouts');

  // Nimm alle Workouts aus einer Collection
  static Stream<List<Workout>> get streamWorkouts =>
      firestore.FirebaseFirestore.instance
          .collection('workouts')
          .snapshots()
          .map(
            (event) => event.docs.map((e) {
              return Workout.fromJson(e.id, e.data());
            }).toList(),
          );
}
