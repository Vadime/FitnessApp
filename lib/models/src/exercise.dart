import 'package:fitnessapp/models/models.dart';

class Exercise {
  final String uid;
  final String name;
  final String description;
  final List<String>? imageURLs;
  final List<ExerciseMuscles> muscles;
  final double caloriesBurned;

  static Exercise emptyExercise = const Exercise(
    uid: '-',
    name: '-',
    description: '-',
    muscles: [ExerciseMuscles.other],
    caloriesBurned: 0,
  );

  const Exercise({
    required this.uid,
    required this.name,
    required this.description,
    this.imageURLs,
    required this.muscles,
    required this.caloriesBurned,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'description': description,
        'imageURLs': imageURLs,
        'muscles': muscles.map((e) => e.index).toList(),
        'caloriesBurned': caloriesBurned,
      };

  factory Exercise.fromJson(String uid, Map<String, dynamic> json) => Exercise(
        uid: uid,
        name: json['name'],
        description: json['description'],
        imageURLs: (json['imageURLs'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        muscles: (json['muscles'] as List<dynamic>)
            .map((e) => ExerciseMuscles.values[e])
            .toList(),
        caloriesBurned:
            json.containsKey('caloriesBurned') ? json['caloriesBurned'] : 20,
      );

  // copyWith
  Exercise copyWith({
    String? uid,
    String? name,
    String? description,
    List<String>? imageURLs,
    List<ExerciseMuscles>? muscles,
  }) {
    return Exercise(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      description: description ?? this.description,
      imageURLs: imageURLs ?? this.imageURLs,
      muscles: muscles ?? List.from(this.muscles),
      caloriesBurned: caloriesBurned,
    );
  }
}
