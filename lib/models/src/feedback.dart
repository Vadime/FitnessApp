
import 'package:widgets/widgets/widgets.dart';

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
      date: json['date'] ?? DateTime.now().str,
    );
  }
}
