part of 'database.dart';

class WorkoutStatisticsRepository {
  static Future<List<DateTime>> getWorkoutDatesStatistics() async {
    var res = await firestore.FirebaseFirestore.instance
        .collectionGroup('workoutStatistics')
        .get();
    var dates = res.docs
        .map(
          (e) => (e.data()['date'] ?? DateTime.now().formattedDate)
              .toString()
              .toDateTime(),
        )
        .toList();
    dates.sort((a, b) => a.compareTo(b));
    return dates;
  }
}
