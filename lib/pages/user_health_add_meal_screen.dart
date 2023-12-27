import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserHealthAddMealScreen extends StatefulWidget {
  final MealType meal;
  final Product product;
  const UserHealthAddMealScreen({
    required this.meal,
    required this.product,
    super.key,
  });

  @override
  State<UserHealthAddMealScreen> createState() =>
      _UserHealthAddMealScreenState();
}

class _UserHealthAddMealScreenState extends State<UserHealthAddMealScreen> {
  late double amount;

  @override
  void initState() {
    amount = widget.product.amount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double calcAmount = amount / widget.product.amount;

    return ScaffoldWidget(
      title: widget.product.name,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ImageWidget(
            NetworkImage(widget.product.imageUrl),
            height: 250,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          TableWidget(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            rows: [
              TableRowWidget(
                cells: [
                  'Kalorien',
                  (widget.product.calories * calcAmount).toStringAsFixed(2),
                ],
              ),
              TableRowWidget(
                cells: [
                  'Kohlenhydrate',
                  (widget.product.carbs * calcAmount).toStringAsFixed(2),
                ],
              ),
              TableRowWidget(
                cells: [
                  'Fett',
                  (widget.product.fat * calcAmount).toStringAsFixed(2),
                ],
              ),
              TableRowWidget(
                cells: [
                  'Protein',
                  (widget.product.protein * calcAmount).toStringAsFixed(2),
                ],
              ),
            ],
          ),
          CardWidget(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  const TextWidget(
                    'Menge',
                  ),
                  const Expanded(
                    child: SizedBox(width: 20),
                  ),
                  TextWidget(
                    '$amount g',
                  ),
                ],
              ),
              Slider(
                min: 0,
                max: 2000,
                divisions: 100,
                value: amount,
                label: '${amount.round()}',
                onChanged: (newAmount) {
                  setState(() {
                    amount = newAmount;
                  });
                },
                onChangeEnd: (newAmount) {
                  // Sie können hier zusätzliche Aktionen durchführen, nachdem der Benutzer die Interaktion beendet hat
                },
              ),
              Row(
                children: [
                  TextWidget(
                    '0 g',
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const Expanded(
                    child: SizedBox(width: 20),
                  ),
                  TextWidget(
                    '2000 g',
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      primaryButton: ElevatedButtonWidget(
        'Zum ${widget.meal.str} hinzufügen',
        onPressed: () async {
          /// add product to meal
          var p = widget.product.copyWith(
            calories: calcAmount * widget.product.calories,
            carbs: calcAmount * widget.product.carbs,
            fat: calcAmount * widget.product.fat,
            protein: calcAmount * widget.product.protein,
            amount: amount,
          );
          await FoodRepository.addProductToMeal(
            p,
            widget.meal,
          );
          FoodRepository.currentFood!.products[widget.meal]!.add(
            p,
          );
          Navigation.flush(
            widget: const HomeScreen(
              initialIndex: 2,
            ),
          );
        },
      ),
    );
  }
}
