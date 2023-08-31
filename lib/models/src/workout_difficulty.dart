import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

extension WorkoutDifficultyExtension on WorkoutDifficulty {
  String get str {
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

  Color getColor(BuildContext context) {
    switch (this) {
      case WorkoutDifficulty.easy:
        return context.config.primaryColor.withOpacity(0.3);
      case WorkoutDifficulty.medium:
        return context.config.primaryColor.withOpacity(0.7);
      case WorkoutDifficulty.hard:
        return context.config.primaryColor;
      default:
        return Colors.black;
    }
  }
}

enum WorkoutDifficulty {
  easy,
  medium,
  hard,
}
