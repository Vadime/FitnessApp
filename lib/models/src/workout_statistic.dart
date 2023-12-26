import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessapp/models/models.dart';

class WorkoutStatistic {
  final String uid;
  final String workoutId;
  final WorkoutDifficulty difficulty;
  final DateTime? startTime;
  final DateTime? endTime;

  /// for gamification
  final int points = 100;

  const WorkoutStatistic({
    required this.uid,
    required this.workoutId,
    required this.difficulty,
    this.startTime,
    this.endTime,
  });

  factory WorkoutStatistic.fromJson(String uid, Map<String, dynamic> data) {
    return WorkoutStatistic(
      uid: uid,
      workoutId: data['uid'],
      difficulty: WorkoutDifficulty.values
          .firstWhere((e) => e.name == data['difficulty']),
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': workoutId,
        'difficulty': difficulty.name,
        'startTime': Timestamp.fromDate(startTime ?? DateTime.now()),
        'endTime': Timestamp.fromDate(startTime ?? DateTime.now()),
      };

  // calc workout duration
  Duration get duration => endTime!.difference(startTime!);

  @override
  bool operator ==(other) {
    return (other is WorkoutStatistic) && uid == other.uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
