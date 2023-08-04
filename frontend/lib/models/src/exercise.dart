import 'package:equatable/equatable.dart';
import 'package:fitness_app/models/models.dart';

class Exercise extends Equatable {
  final String uid;
  final String name;
  final String description;
  String? imageURL;
  final List<ExerciseMuscles> muscles;
  final ExerciseDifficulty difficulty;

  Exercise({
    required this.uid,
    required this.name,
    required this.description,
    this.imageURL,
    required this.muscles,
    required this.difficulty,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'imageURL': imageURL,
        'muscles': muscles.map((e) => e.index).toList(),
        'difficulty': difficulty.index,
      };

  factory Exercise.fromJson(String uid, Map<String, dynamic> json) => Exercise(
        uid: uid,
        name: json['name'],
        description: json['description'],
        imageURL: json['imageURL'],
        muscles: (json['muscles'] as List<dynamic>)
            .map((e) => ExerciseMuscles.values[e])
            .toList(),
        difficulty: ExerciseDifficulty.values[json['difficulty']],
      );

  @override
  List<Object?> get props => [
        uid,
        name,
        description,
        imageURL,
        muscles,
        difficulty,
      ];
}
