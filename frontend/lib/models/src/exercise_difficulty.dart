extension ExerciseDifficultyExtension on ExerciseDifficulty {
  String get strName {
    switch (this) {
      case ExerciseDifficulty.easy:
        return 'Easy';
      case ExerciseDifficulty.medium:
        return 'Medium';
      case ExerciseDifficulty.hard:
        return 'Hard';
      default:
        return '';
    }
  }
}

enum ExerciseDifficulty {
  easy,
  medium,
  hard,
}
