extension ExerciseMusclesExtension on ExerciseMuscles {
  String get strName {
    switch (this) {
      case ExerciseMuscles.chest:
        return 'Chest';
      case ExerciseMuscles.back:
        return 'Back';
      case ExerciseMuscles.shoulders:
        return 'Shoulders';
      case ExerciseMuscles.biceps:
        return 'Biceps';
      case ExerciseMuscles.triceps:
        return 'Triceps';
      case ExerciseMuscles.legs:
        return 'Legs';
      case ExerciseMuscles.abs:
        return 'Abs';
      case ExerciseMuscles.cardio:
        return 'Cardio';
      case ExerciseMuscles.fullBody:
        return 'Full Body';
      case ExerciseMuscles.other:
        return 'Other';
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
