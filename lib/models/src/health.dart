import 'package:fitnessapp/models/src/health_goal.dart';
import 'package:widgets/widgets.dart';

class Health {
  /// in kg
  final double weight;

  /// in cm
  final double height;

  /// in years
  final DateTime birthDate;

  /// helps calculating the [bmr]
  final Gender gender;

  /// goal
  final HealthGoal? goal;

  Health({
    required this.weight,
    required this.height,
    required this.birthDate,
    required this.gender,
    this.goal,
  });

  factory Health.fromJson(Map<Object?, Object?> json) => Health(
        weight: json['weight'] as double,
        height: json['height'] as double,
        birthDate: DateTime.parse(json['birthDate'].toString()),
        gender: genderFromString(json['gender'] as String) ?? Gender.male,
      );

  Map<String, dynamic> toJson() => {
        'weight': weight,
        'height': height,
        'birthDate': birthDate.toIso8601String(),
        'gender': gender.str,
      };

  double get bmi => weight / (height * height);

  int get age => DateTime.now().difference(birthDate).inDays ~/ 365;

  /// Harris-Benedict-Formel -> Basal Metabolic Rate
  double get bmr {
    if (gender == Gender.male) {
      return 66.47 + (13.75 * weight) + (5.003 * height) - (6.755 * age);
    } else if (gender == Gender.female) {
      return 655.1 + (9.563 * weight) + (1.85 * height) - (4.676 * age);
    }

    /// if unknown we will do female
    return 655.1 + (9.563 * weight) + (1.85 * height) - (4.676 * age);
  }
}
