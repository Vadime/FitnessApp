import 'package:cloud_firestore/cloud_firestore.dart';
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

  /// health date to track the health over time
  DateTime date;

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
    required this.date,
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
        date: (json['date'] as Timestamp).toDate().dateOnly,
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

  /// get total calories from [bmr]
  /// 1g carbs = 4.1 calories
  /// 1g protein = 4.1 calories
  /// 1g fat = 9.3 calories
  /// get total calories from [bmr]
  double get totalCalories => bmr;

  /// get breakfast calories from [totalCalories]
  double get breakfastCalories => totalCalories * 0.225;

  /// get lunch calories from [totalCalories]
  double get lunchCalories => totalCalories * 0.325;

  /// get dinner calories from [totalCalories]
  double get dinnerCalories => totalCalories * 0.275;

  /// get snacks calories from [totalCalories]
  double get snacksCalories => totalCalories * 0.175;

  // copyWith
  Health copyWith({
    double? weight,
    int? height,
    DateTime? birthDate,
    Gender? gender,
    DateTime? date,
    HealthGoal? goal,
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
