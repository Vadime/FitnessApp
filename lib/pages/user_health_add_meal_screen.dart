import 'package:fitnessapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class Product {
  final String name;

  final String? imageUrl;

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
    this.imageUrl,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.amount,
  });
}

class UserHealthAddMealScreen extends StatefulWidget {
  final Meal meal;
  const UserHealthAddMealScreen({
    required this.meal,
    super.key,
  });

  @override
  State<UserHealthAddMealScreen> createState() =>
      _UserHealthAddMealScreenState();
}

class _UserHealthAddMealScreenState extends State<UserHealthAddMealScreen> {
  late List<Product> filteredProducts;
  final List<Product> products = [
    Product(
      name: 'Banane',
      imageUrl:
          'https://www.alnatura.de/-/media/Alnatura/B2C/Bilder/magazin/warenkunde/2400x1350/Warenkunde_Bananen_Quer_2_Quelle_Alnatura_Fotograf_Oliver_Brachat-1.jpg',
      calories: 100,
      carbs: 10,
      protein: 10,
      fat: 10,
      amount: 100,
    ),
    Product(
      name: 'Apfel',
      imageUrl: 'https://www.vegpool.de/magazin/images/2019-08/apfel-rot.jpg',
      calories: 100,
      carbs: 10,
      protein: 10,
      fat: 10,
      amount: 100,
    ),
    Product(
      name: 'Steak',
      imageUrl: 'https://www.vegpool.de/magazin/images/2019-08/apfel-rot.jpg',
      calories: 100,
      carbs: 10,
      protein: 10,
      fat: 10,
      amount: 100,
    ),
  ];

  TextFieldController searchController =
      TextFieldController('Suche nach Lebensmittel...');

  @override
  void initState() {
    filteredProducts = List.from(products);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: '${widget.meal.str} hinzufügen',
      actions: [
        IconButton(
          icon: const Icon(Icons.qr_code_scanner_rounded),
          onPressed: () {
            /// scan bar code
          },
        ),
      ],
      body: Builder(
        builder: (context) {
          return ListView(
            physics: const ScrollPhysics(),
            children: [
              // search bar
              TextFieldWidget(
                controller: searchController,
                margin: const EdgeInsets.all(20),
                onChanged: (v) {
                  /// search for products, update list
                  setState(() {
                    filteredProducts = products
                        .where(
                          (element) => element.name
                              .toLowerCase()
                              .contains(v.toLowerCase()),
                        )
                        .toList();
                  });
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  context.config.padding,
                  0,
                  context.config.padding,
                  context.config.padding,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ListTileWidget(
                    title: product.name,
                    subtitle: '${product.calories} kcal',
                    trailing: ImageWidget(
                      product.imageUrl != null
                          ? NetworkImage(product.imageUrl!)
                          : null,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      double amount = product.amount;

                      /// add product to meal
                      Navigation.pushPopup(
                        widget: StatefulBuilder(
                          builder: (context, setState) {
                            double calcAmount = amount / product.amount;

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                      product.name,
                                      style: context.textTheme.headlineLarge,
                                    ),
                                    const Expanded(child: SizedBox(width: 20)),
                                    if (product.imageUrl != null)
                                      ImageWidget(
                                        NetworkImage(product.imageUrl!),
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                TableWidget(
                                  rows: [
                                    TableRowWidget(
                                      cells: [
                                        'Kalorien',
                                        (product.calories * calcAmount)
                                            .toStringAsFixed(2),
                                      ],
                                    ),
                                    TableRowWidget(
                                      cells: [
                                        'Kohlenhydrate',
                                        (product.carbs * calcAmount)
                                            .toStringAsFixed(2),
                                      ],
                                    ),
                                    TableRowWidget(
                                      cells: [
                                        'Protein',
                                        (product.protein * calcAmount)
                                            .toStringAsFixed(2),
                                      ],
                                    ),
                                    TableRowWidget(
                                      cells: [
                                        'Fett',
                                        (product.fat * calcAmount)
                                            .toStringAsFixed(2),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                CardWidget(
                                  padding: const EdgeInsets.all(20),
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
                                          color: Colors.grey.shade400,
                                        ),
                                        const Expanded(
                                          child: SizedBox(width: 20),
                                        ),
                                        TextWidget(
                                          '2000 g',
                                          color: Colors.grey.shade400,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ElevatedButtonWidget(
                                  'Zum ${widget.meal.str} hinzufügen',
                                  onPressed: () {
                                    /// add product to meal
                                    Navigation.pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
