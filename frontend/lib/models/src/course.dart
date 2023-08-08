
import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String uid;
  final String name;
  final String description;
  String? imageURL;

  final String date;

  Course({
    required this.uid,
    required this.name,
    required this.description,
    required this.date,
    this.imageURL,
  });

  // to json
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'date': date,
        'imageURL': imageURL,
      };

  // from json
  factory Course.fromJson(String uid, Map<String, dynamic> json) => Course(
        uid: uid,
        name: json['name'],
        description: json['description'],
        date: json['date'],
        imageURL: json['imageURL'],
      );

  @override
  List<Object?> get props => [uid, name, description, date, imageURL];
}
