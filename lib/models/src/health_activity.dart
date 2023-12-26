enum HealthActivity {
  none,
  light,
  moderate,
  heavy,
  extreme,
}

HealthActivity healthActivityFromString(String? str) {
  switch (str) {
    case 'HealthActivity.light':
      return HealthActivity.light;
    case 'HealthActivity.moderate':
      return HealthActivity.moderate;
    case 'HealthActivity.heavy':
      return HealthActivity.heavy;
    case 'HealthActivity.extreme':
      return HealthActivity.extreme;
    default:
      return HealthActivity.none;
  }
}

extension HealthActivityExtension on HealthActivity {
  String get str {
    switch (this) {
      case HealthActivity.light:
        return 'Leicht';
      case HealthActivity.moderate:
        return 'Mittel';
      case HealthActivity.heavy:
        return 'Aktiv';
      case HealthActivity.extreme:
        return 'Sehr Aktiv';
      default:
        return 'Garnicht';
    }
  }

  double get calorieChange {
    switch (this) {
      case HealthActivity.light:
        return 200;
      case HealthActivity.moderate:
        return 400;
      case HealthActivity.heavy:
        return 600;
      default:
        return 0;
    }
  }

  String get description {
    switch (this) {
      case HealthActivity.light:
        return 'Du sitzt den ganzen Tag.';
      case HealthActivity.moderate:
        return 'Du sitzt und stehst den ganzen Tag.';
      case HealthActivity.heavy:
        return 'Du stehst und bewegst dich den ganzen Tag.';
      case HealthActivity.extreme:
        return 'Du bewegst dich den ganzen Tag.';
      default:
        return 'Du sitzt den ganzen Tag und machst keinen Sport.';
    }
  }
}
