import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String text;
  final bool isUser;
  late final DateTime timestamp;

  Message({
    required this.text,
    required this.isUser,
  }) {
    timestamp = DateTime.now();
  }

  // fromJson
  Message.fromJson(String uid, Map<String, dynamic> json)
      : text = json['text'] as String,
        isUser = json['isUser'] as bool,
        // use firebase Timestamp to convert to DateTime
        timestamp = (json['timestamp'] as Timestamp).toDate();

  // toJson
  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
        'timestamp': Timestamp.fromDate(timestamp),
      };
}
