import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:widgets/widgets.dart';

class WorkoutStatistic {
  final String uid;
  final Workout workout;
  final List<Exercise> exercises;
  final WorkoutDifficulty difficulty;
  final DateTime? date;
  final DateTime? startTime;
  final DateTime? endTime;

  /// for gamification
  final int points = 100;

  const WorkoutStatistic({
    required this.uid,
    required this.workout,
    required this.exercises,
    required this.difficulty,
    this.date,
    this.startTime,
    this.endTime,
  });

  factory WorkoutStatistic.fromJson(String uid, Map<String, dynamic> data) {
    return WorkoutStatistic(
      uid: uid,
      workout: Workout.fromJson(
        data['workoutId'],
        data['workout'] as Map<String, dynamic>,
      ),
      exercises: (data['exercises'] as List<dynamic>)
          .map(
            (e) => Exercise.fromJson(
              e.containsKey('uid') ? e['uid'] : '',
              e,
            ),
          )
          .toList(),
      difficulty: WorkoutDifficulty.values
          .firstWhere((e) => e.name == data['difficulty']),
      date: (data['date'] as Timestamp).toDate().dateOnly,
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        'workoutId': workout.uid,
        'workout': workout.toJson(),
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'difficulty': difficulty.name,
        'date': Timestamp.fromDate(date?.dateOnly ?? DateTime.now().dateOnly),
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
