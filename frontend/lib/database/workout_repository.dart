import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:fitness_app/models/models.dart';

class WorkoutRepository {
  // Nimm alle Workouts aus einer Collection
  static Stream<List<Workout>> get streamWorkouts => firestore
      .FirebaseFirestore.instance
      .collection('workouts')
      .snapshots()
      .map(
        (event) =>
            event.docs.map((e) => Workout.fromJson(e.id, e.data())).toList(),
      );
}

