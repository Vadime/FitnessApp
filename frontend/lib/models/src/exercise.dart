import 'package:equatable/equatable.dart';
import 'package:fitness_app/models/models.dart';

class Exercise extends Equatable {
  final String uid;
  final String name;
  final String description;
  String? imageURL;
  final List<ExerciseMuscles> muscles;

  static Exercise emptyExercise = Exercise(
    uid: '-',
    name: '-',
    description: '-',
    muscles: const [ExerciseMuscles.other],
  );

  Exercise({
    required this.uid,
    required this.name,
    required this.description,
    this.imageURL,
    required this.muscles,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'imageURL': imageURL,
        'muscles': muscles.map((e) => e.index).toList(),
      };

  factory Exercise.fromJson(String uid, Map<String, dynamic> json) => Exercise(
        uid: uid,
        name: json['name'],
        description: json['description'],
        imageURL: json['imageURL'],
        muscles: (json['muscles'] as List<dynamic>)
            .map((e) => ExerciseMuscles.values[e])
            .toList(),
      );

  @override
  List<Object?> get props => [
        uid,
        name,
        description,
        imageURL,
        muscles,
      ];
}
