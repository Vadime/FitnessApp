part of 'database.dart';

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

  // Nimm alle Workouts aus einer Collection
  static Future<List<Workout>> get adminWorkoutsAsFuture async =>
      (await firestore.FirebaseFirestore.instance.collection('workouts').get())
          .docs
          .map(
            (e) => Workout.fromJson(
              e.id,
              e.data(),
            ),
          )
          .toList();

  static Future<void> addWorkout(Workout workout) async {
    await collectionReference.add(workout.toJson());
  }

  static Future<void> updateWorkout(Workout workout) async {
    await collectionReference.doc(workout.uid).update(workout.toJson());
  }

  static Future<void> deleteWorkout(Workout workout) async {
    await collectionReference.doc(workout.uid).delete();
  }
}
