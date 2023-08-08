// date: DateTime.now().toString(), extension to make toString show this format "dd.mm.yyyy"
extension DateTimeExtension on DateTime {
  String get formattedDate =>
      '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.${year.toString().padLeft(4, '0')}';
}

class MyFeedback {
  final String name;
  final String feedback;
  final String date;

  MyFeedback({
    required this.name,
    required this.feedback,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'feedback': feedback,
      'date': date,
    };
  }

  factory MyFeedback.fromJson(Map<String, dynamic> json) {
    return MyFeedback(
      name: json['name'],
      feedback: json['feedback'],
      date: json['date'] ?? DateTime.now().formattedDate,
    );
  }
}
