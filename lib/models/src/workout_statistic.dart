import 'package:fitnessapp/models/models.dart';
import 'package:widgets/widgets.dart';

class WorkoutStatistic {
  final String uid;
  final String workoutId;
  final DateTime dateTime;
  final WorkoutDifficulty difficulty;

  /// for gamification
  final int points = 100;

  const WorkoutStatistic({
    required this.uid,
    required this.workoutId,
    required this.dateTime,
    required this.difficulty,
  });

  factory WorkoutStatistic.fromJson(String uid, Map<String, dynamic> data) {
    return WorkoutStatistic(
      uid: uid,
      workoutId: data['uid'],
      dateTime: data['date'].toString().dateTime,
      difficulty: WorkoutDifficulty.values
          .firstWhere((e) => e.name == data['difficulty']),
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': workoutId,
        'difficulty': difficulty.name,
        'date': DateTime.now().ddMMYYYY,
      };

  @override
  bool operator ==(other) {
    return (other is WorkoutStatistic) && uid == other.uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
