extension SchdeuleExtension on Schedule {
  // strName
  String get str {
    switch (this) {
      case Schedule.daily:
        return 'Täglich';
      case Schedule.twoDaysAWeek:
        return '2x die Woche';
      case Schedule.threeDaysAWeek:
        return '3x die Woche';
      case Schedule.fourDaysAWeek:
        return '4x die Woche';
      case Schedule.weekly:
        return 'Wöchentlich';
      case Schedule.monthly:
        return 'Monatlich';
      case Schedule.none:
        return 'Keins';
      default:
        return 'Keins';
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
