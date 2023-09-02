part of '../modules/database.dart';

class WorkoutRepository {
  static firestore.CollectionReference<Map<String, dynamic>>
      get collectionReference => Store.instance.collection('workouts');

  // Nimm alle Workouts aus einer Collection
  static Stream<List<Workout>> get streamWorkouts {
    try {
      return Store.instance.collection('workouts').snapshots().map(
            (event) => event.docs.map((e) {
              return Workout.fromJson(e.id, e.data());
            }).toList(),
          );
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  // Nimm alle Workouts aus einer Collection
  static Future<List<Workout>> get adminWorkoutsAsFuture async {
    try {
      return (await Store.instance.collection('workouts').get())
          .docs
          .map(
            (e) => Workout.fromJson(
              e.id,
              e.data(),
            ),
          )
          .toList();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> saveWorkout(Workout workout) async {
    try {
      await collectionReference
          .doc(workout.uid)
          .set(workout.toJson(), firestore.SetOptions(merge: true));
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> deleteWorkout(Workout workout) async {
    try {
      await collectionReference.doc(workout.uid).delete();
    } catch (e, s) {
      throw handleException(e, s);
    }
  }
}
