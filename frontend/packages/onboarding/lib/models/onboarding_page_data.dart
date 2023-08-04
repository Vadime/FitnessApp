import 'package:flutter/material.dart' show Color, Colors;

class OnboardingPageData {
  final String title;
  final String description;
  final String image;
  final Color color;
  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.image,
    this.color = Colors.transparent,
  });

  factory OnboardingPageData.fromJson(Map<String, dynamic> json) {
    return OnboardingPageData(
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      color: Color(int.tryParse(json['color']) ?? 0x00000000),
    );
  }

  @override
  int get hashCode =>
      title.hashCode ^ description.hashCode ^ image.hashCode ^ color.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is OnboardingPageData &&
            runtimeType == other.runtimeType &&
            title == other.title &&
            description == other.description &&
            image == other.image &&
            color == other.color;
  }
}
