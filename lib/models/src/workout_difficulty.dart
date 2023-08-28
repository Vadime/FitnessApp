extension WorkoutDifficultyExtension on WorkoutDifficulty {
  String get strName {
    switch (this) {
      case WorkoutDifficulty.easy:
        return 'Easy';
      case WorkoutDifficulty.medium:
        return 'Medium';
      case WorkoutDifficulty.hard:
        return 'Hard';
      default:
        return '';
    }
  }
}

enum WorkoutDifficulty {
  easy,
  medium,
  hard,
}
