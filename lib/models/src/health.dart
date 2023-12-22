import 'package:fitnessapp/models/src/health_goal.dart';
import 'package:widgets/widgets.dart';

class Health {
  /// in kg
  double weight;

  /// in cm
  int height;

  /// in years
  DateTime birthDate;

  /// helps calculating the [bmr]
  Gender gender;

  /// goal
  HealthGoal goal;

  /// macrodistribution
  double carbsPercent;
  double proteinPercent;
  double fatPercent;

  Health({
    required this.weight,
    required this.height,
    required this.birthDate,
    required this.gender,
    this.goal = HealthGoal.stayFit,
    this.carbsPercent = 0.5,
    this.proteinPercent = 0.3,
    this.fatPercent = 0.2,
  });

  factory Health.fromJson(Map<Object?, Object?> json) => Health(
        weight: json['weight'] as double,
        height: json['height'] as int,
        birthDate: DateTime.parse(json['birthDate'].toString()),
        gender: genderFromString(json['gender'] as String),
        goal: healthGoalFromString(json['goal'] as String),
        carbsPercent: json['carbsPercent'] as double,
        proteinPercent: json['proteinPercent'] as double,
        fatPercent: json['fatPercent'] as double,
      );

  Map<String, dynamic> toJson() => {
        'weight': weight,
        'height': height,
        'birthDate': birthDate.toIso8601String(),
        'gender': gender.str,
        'goal': goal.str,
        'carbsPercent': carbsPercent,
        'proteinPercent': proteinPercent,
        'fatPercent': fatPercent,
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

  /// get carbs in g from [bmr] and [carbsPercent]
  double get carbs => bmr * carbsPercent / 4.1;

  /// get protein in g from [bmr] and [proteinPercent]
  double get protein => bmr * proteinPercent / 4.1;

  /// get fat in g from [bmr] and [fatPercent]
  double get fat => bmr * fatPercent / 9.3;

  // copy
  Health copy() => Health(
        weight: weight,
        height: height,
        birthDate: birthDate.copyWith(),
        gender: gender,
      );

  static Health empty() => Health(
        weight: 70,
        height: 180,
        birthDate: DateTime(2000),
        gender: Gender.male,
      );
}
