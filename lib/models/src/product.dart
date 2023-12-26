class Product {
  final String name;

  final String imageUrl;

  /// in kcal
  final double calories;

  /// in g
  final double carbs;

  /// in g
  final double protein;

  /// in g
  final double fat;

  /// in g
  final double amount;

  Product({
    required this.name,
    this.imageUrl = '',
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.amount,
  });

  factory Product.fromJson(Map<String, Object?> json) => Product(
        name: json['name'].toString(),
        imageUrl: json['imageUrl'].toString(),
        calories: json['calories'] as double,
        carbs: json['carbs'] as double,
        protein: json['protein'] as double,
        fat: json['fat'] as double,
        amount: json['amount'] as double,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'imageUrl': imageUrl,
        'calories': calories,
        'carbs': carbs,
        'protein': protein,
        'fat': fat,
        'amount': amount,
      };

  // copyWith
  Product copyWith({
    String? name,
    String? imageUrl,
    double? calories,
    double? carbs,
    double? protein,
    double? fat,
    double? amount,
  }) {
    return Product(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      calories: calories ?? this.calories,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      amount: amount ?? this.amount,
    );
  }
}
