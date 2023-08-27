extension SchdeuleExtension on Schedule {
  // strName
  String get strName {
    switch (this) {
      case Schedule.daily:
        return 'Daily';
      case Schedule.twoDaysAWeek:
        return '2 Days a Week';
      case Schedule.threeDaysAWeek:
        return '3 Days a Week';
      case Schedule.fourDaysAWeek:
        return '4 Days a Week';
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
  threeDaysAWeek,
  fourDaysAWeek,
  twoDaysAWeek,
  monthly,
  weekly,
  daily,
  none,
}
