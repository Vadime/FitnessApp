import 'package:fitness_app/models/models.dart';

class Exercise {
  final String uid;
  final String name;
  final String description;
  final String? imageURL;
  final List<ExerciseMuscles> muscles;

  static Exercise emptyExercise = const Exercise(
    uid: '-',
    name: '-',
    description: '-',
    muscles: [ExerciseMuscles.other],
  );

  const Exercise({
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
}
