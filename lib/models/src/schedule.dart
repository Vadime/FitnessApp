extension SchdeuleExtension on Schedule {
  // strName
  String get str {
    switch (this) {
      case Schedule.daily:
        return 'Daily';
      case Schedule.twoDaysAWeek:
        return '2x a week';
      case Schedule.threeDaysAWeek:
        return '3x a Week';
      case Schedule.fourDaysAWeek:
        return '4x a Week';
      case Schedule.weekly:
        return 'Weekly';
      case Schedule.monthly:
        return 'Monthly';
      case Schedule.none:
        return 'None';
      default:
        return 'None';
    }
  }
}

enum Schedule {
  none,
  threeDaysAWeek,
  fourDaysAWeek,
  twoDaysAWeek,
  monthly,
  weekly,
  daily,
}
