enum MealType {
  breakfast,
  lunch,
  dinner,
  snacks,
}

MealType mealTypeFromJson(String json) {
  switch (json) {
    case 'MealType.breakfast':
      return MealType.breakfast;
    case 'MealType.lunch':
      return MealType.lunch;
    case 'MealType.dinner':
      return MealType.dinner;
    default:
      return MealType.snacks;
  }
}

extension MealExtension on MealType {
  String get str {
    switch (this) {
      case MealType.breakfast:
        return 'Frühstück';
      case MealType.lunch:
        return 'Mittagessen';
      case MealType.dinner:
        return 'Abendessen';
      case MealType.snacks:
        return 'Snacks';
    }
  }
}
