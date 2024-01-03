import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessapp/models/src/health_activity.dart';
import 'package:fitnessapp/models/src/health_goal.dart';
import 'package:widgets/widgets.dart';

class Health {
  /// in kg
  double weight;

  /// in cm
  int height;

  /// in years
  DateTime birthDate;

  /// helps calculating the bmr
  Gender gender;

  /// health date to track the health over time
  DateTime date;

  /// goal
  HealthGoal goal;

  HealthActivity activity;

  /// macrodistribution
  double carbsPercent;
  double proteinPercent;
  double fatPercent;

  Health({
    required this.weight,
    required this.height,
    required this.birthDate,
    required this.gender,
    required this.date,
    this.goal = HealthGoal.stayFit,
    this.activity = HealthActivity.none,
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
        date: (json['date'] as Timestamp).toDate().dateOnly,
        activity: healthActivityFromString(json['activity'] as String?),
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
        'date': Timestamp.fromDate(date.dateOnly),
        'activity': activity.name,
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

  /// get total calories
  double get totalCalories => bmr + goal.calorieChange + activity.calorieChange;

  /// get carbs in g
  double get carbs => totalCalories * carbsPercent / 4.1;

  /// get protein in g
  double get protein => totalCalories * proteinPercent / 4.1;

  /// get fat in g
  double get fat => totalCalories * fatPercent / 9.3;

  /// get breakfast calories
  double get breakfastCalories => totalCalories * 0.225;

  /// get lunch calories
  double get lunchCalories => totalCalories * 0.325;

  /// get dinner calories
  double get dinnerCalories => totalCalories * 0.275;

  /// get snacks calories
  double get snacksCalories => totalCalories * 0.175;

  /// get water in ml
  int get water => (weight * 35).toInt();

  // copyWith
  Health copyWith({
    double? weight,
    int? height,
    DateTime? birthDate,
    Gender? gender,
    DateTime? date,
    HealthGoal? goal,
    HealthActivity? activity,
    double? carbsPercent,
    double? proteinPercent,
    double? fatPercent,
  }) {
    return Health(
      weight: weight ?? this.weight,
      height: height ?? this.height,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      date: date ?? this.date,
      goal: goal ?? this.goal,
      carbsPercent: carbsPercent ?? this.carbsPercent,
      proteinPercent: proteinPercent ?? this.proteinPercent,
      fatPercent: fatPercent ?? this.fatPercent,
      activity: activity ?? this.activity,
    );
  }

  static Health empty(DateTime date) => Health(
        weight: 70,
        height: 180,
        birthDate: DateTime(2000),
        gender: Gender.male,
        date: date,
      );
}
