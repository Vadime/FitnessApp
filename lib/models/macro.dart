enum Macro {
  carbohydrate,
  protein,
  fat,
}

// to String
extension MacroExtension on Macro {
  String get str {
    switch (this) {
      case Macro.carbohydrate:
        return 'Kohlenhydrate';
      case Macro.protein:
        return 'Protein';
      case Macro.fat:
        return 'Fett';
    }
  }
}
