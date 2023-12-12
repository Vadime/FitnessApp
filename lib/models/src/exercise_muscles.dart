extension ExerciseMusclesExtension on ExerciseMuscles {
  String get str {
    switch (this) {
      case ExerciseMuscles.chest:
        return 'Brust';
      case ExerciseMuscles.back:
        return 'Rücken';
      case ExerciseMuscles.shoulders:
        return 'Schultern';
      case ExerciseMuscles.biceps:
        return 'Bizeps';
      case ExerciseMuscles.triceps:
        return 'Trizeps';
      case ExerciseMuscles.legs:
        return 'Beine';
      case ExerciseMuscles.abs:
        return 'Bauch';
      case ExerciseMuscles.cardio:
        return 'Cardio';
      case ExerciseMuscles.fullBody:
        return 'Ganzkörper';
      case ExerciseMuscles.other:
        return 'Sonstiges';
    }
  }
}

enum ExerciseMuscles {
  shoulders,
  fullBody,
  triceps,
  cardio,
  biceps,
  chest,
  other,
  back,
  legs,
  abs,
}
