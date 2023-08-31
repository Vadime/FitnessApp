part of 'database.dart';

class WorkoutStatisticsRepository {
  static Future<List<WorkoutStatistic>> getWorkoutDatesStatistics() async {
    try {
      var res = await firestore.FirebaseFirestore.instance
          .collectionGroup('workoutStatistics')
          .get();
      var workouts = res.docs
          .map((e) => WorkoutStatistic.fromJson(e.id, e.data()))
          .toList();
      workouts.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      return workouts;
    } catch (e, s) {
      throw handleException(e, s);
    }
  }
}
