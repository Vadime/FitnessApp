enum Meal {
  breakfast,
  lunch,
  dinner,
  snacks,
}

extension MealExtension on Meal {
  String get str {
    switch (this) {
      case Meal.breakfast:
        return 'Frühstück';
      case Meal.lunch:
        return 'Mittagessen';
      case Meal.dinner:
        return 'Abendessen';
      case Meal.snacks:
        return 'Snacks';
    }
  }
}
