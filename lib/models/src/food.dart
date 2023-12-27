import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessapp/models/models.dart';

/// A food object.
/// contains all the food eaten at a specific date seperated by meal type.
class Food {
  final Map<MealType, List<Product>> products;
  DateTime date;
  int water;
  Food({
    required this.products,
    required this.date,
    this.water = 0,
  });

  factory Food.fromJson(Map<Object?, Object?> json) => Food(
        products: (json['products'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            mealTypeFromJson(key.toString()),
            (value as List)
                .map((e) => Product.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
        ),
        date: (json['date'] as Timestamp).toDate(),
        water: json['water'] as int,
      );

  Map<String, dynamic> toJson() => {
        'products': products.map(
          (key, value) => MapEntry<String, List<Map<String, dynamic>>>(
            key.toString(),
            value.map((e) => e.toJson()).toList(),
          ),
        ),
        'date': Timestamp.fromDate(date),
        'water': water,
      };

  // copyWith
  Food copyWith({
    Map<MealType, List<Product>>? products,
    DateTime? date,
    int? water,
  }) {
    return Food(
      products: products ?? this.products,
      date: date ?? this.date,
      water: water ?? this.water,
    );
  }

  static Food empty(DateTime date) => Food(
        products: {
          MealType.breakfast: [],
          MealType.lunch: [],
          MealType.dinner: [],
          MealType.snacks: [],
        },
        date: date,
        water: 0,
      );

  // calculate the total calories of all products
  double get totalCalories => products.values
      .map(
        (List<Product> e) => e.fold(
          0.0,
          (previousValue, element) => previousValue + element.calories,
        ),
      )
      .fold(0, (previousValue, element) => previousValue + element);

  // calculate the total carbs of all products in grams
  double get totalCarbs => products.values
      .map(
        (List<Product> e) => e.fold(
          0.0,
          (previousValue, element) => previousValue + element.carbs,
        ),
      )
      .fold(0, (previousValue, element) => previousValue + element);

  // calculate the total fat of all products in grams
  double get totalFat => products.values
      .map(
        (List<Product> e) => e.fold(
          0.0,
          (previousValue, element) => previousValue + element.fat,
        ),
      )
      .fold(0, (previousValue, element) => previousValue + element);

  // calculate the total protein of all products in grams
  double get totalProtein => products.values
      .map(
        (List<Product> e) => e.fold(
          0.0,
          (previousValue, element) => previousValue + element.protein,
        ),
      )
      .fold(0, (previousValue, element) => previousValue + element);

  // calculate the total calories of products in breakfast
  double get breakfastCalories => products[MealType.breakfast]!
      .fold(0.0, (previousValue, element) => previousValue + element.calories);

  // calculate the total calories of products in lunch
  double get lunchCalories => products[MealType.lunch]!
      .fold(0.0, (previousValue, element) => previousValue + element.calories);

  // calculate the total calories of products in dinner
  double get dinnerCalories => products[MealType.dinner]!
      .fold(0.0, (previousValue, element) => previousValue + element.calories);

  // calculate the total calories of products in snacks
  double get snacksCalories => products[MealType.snacks]!
      .fold(0.0, (previousValue, element) => previousValue + element.calories);
}
