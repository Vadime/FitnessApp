import 'package:fitnessapp/database/database.dart';

class Course {
  final String uid;
  final String name;
  final String description;
  final String? imageURL;
  final List<String> userUIDS;

  final DateTime date;

  const Course({
    required this.uid,
    required this.name,
    required this.description,
    required this.date,
    required this.userUIDS,
    this.imageURL,
  });

  // to json
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'date': date.toDate(),
        'imageURL': imageURL,
        'userUIDS': userUIDS,
      };

  // from json
  factory Course.fromJson(String uid, Map<String, dynamic> json) => Course(
        uid: uid,
        name: json['name'],
        description: json['description'],
        date: (json['date'] as String).toDateTime(),
        imageURL: json['imageURL'],
        userUIDS: List<String>.from(json['userUIDS'] ?? []),
      );
}
