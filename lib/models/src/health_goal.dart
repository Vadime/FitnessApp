enum HealthGoal { gainWeight, loseWeight, stayFit }

HealthGoal healthGoalFromString(String? str) {
  switch (str) {
    case 'gainWeight':
      return HealthGoal.gainWeight;
    case 'loseWeight':
      return HealthGoal.loseWeight;
    default:
      return HealthGoal.stayFit;
  }
}

extension HealthGoalExtension on HealthGoal {
  String get str {
    switch (this) {
      case HealthGoal.gainWeight:
        return 'Zunehmen';
      case HealthGoal.loseWeight:
        return 'Abnehmen';
      default:
        return 'Fit bleiben';
    }
  }
}
