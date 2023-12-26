part of '../modules/database.dart';

class WorkoutStatisticsRepository {
  static Future<List<WorkoutStatistic>> getWorkoutDatesStatistics() async {
    try {
      var res = await Store.instance.collectionGroup('workoutStatistics').get();
      var workouts = res.docs
          .map((e) => WorkoutStatistic.fromJson(e.id, e.data()))
          .toList();
      workouts.sort(
          (a, b) => a.startTime?.compareTo(b.startTime ?? DateTime.now()) ?? 0);
      return workouts;
    } catch (e, s) {
      throw handleException(e, s);
    }
  }
}
