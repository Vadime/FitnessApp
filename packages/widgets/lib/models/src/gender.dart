import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Gender? genderFromString(String value) {
  switch (value.toLowerCase()) {
    case 'male':
      return Gender.male;
    case 'female':
      return Gender.female;
    case 'other':
      return Gender.other;
    default:
      return null;
  }
}


enum Gender { male, female, other }

extension GenderExtension on Gender? {
  String get str {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
      default:
        return 'Unknown';
    }
  }

  IconData get icon {
    switch (this) {
      case Gender.male:
        return Icons.male_rounded;
      case Gender.female:
        return Icons.female_rounded;
      case Gender.other:
        return FontAwesomeIcons.genderless;
      default:
        return Icons.error;
    }
  }

}
