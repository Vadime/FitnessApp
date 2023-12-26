import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/user_health_add_meal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:widgets/widgets.dart';

import '../database/modules/database.dart';

class UserHealthMealInfoScreen extends StatefulWidget {
  final MealType meal;
  const UserHealthMealInfoScreen({
    required this.meal,
    super.key,
  });

  @override
  State<UserHealthMealInfoScreen> createState() =>
      _UserHealthMealInfoScreenState();
}

class _UserHealthMealInfoScreenState extends State<UserHealthMealInfoScreen> {
  List<Product>? products;
  List<Product> filteredProducts = [];

  TextFieldController searchController =
      TextFieldController('Suche nach Lebensmittel...');

  @override
  void initState() {
    ProductRepository.getProducts().then(
      (value) => setState(() {
        products = value;
        filteredProducts = List.from(products!);
      }),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: '${widget.meal.str} hinzufügen',
      actions: [
        IconButton(
          icon: const Icon(Icons.qr_code_scanner_rounded),
          onPressed: () async {
            String info = await FlutterBarcodeScanner.scanBarcode(
              '#ff6666',
              'Cancel',
              true,
              ScanMode.BARCODE,
            );
            Logging.log('BarCode Result: $info');
          },
        ),
      ],
      body: ListView(
        physics: const ScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          0,
          0,
          0,
          context.config.padding,
        ),
        children: [
          FutureBuilder(
            future: MealRepository.getImageForMealType(widget.meal),
            builder: (context, snap) => ImageWidget(
              snap.data != null ? NetworkImage(snap.data.toString()) : null,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          TextWidget(
            'Bereits gegessen',
            style: Theme.of(context).textTheme.bodyLarge,
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          ),
          TableWidget(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            rows: [
              const TableRowWidget(
                cells: [
                  'Name',
                  'Menge',
                  'Kalorien',
                ],
              ),
              // write the products dynamically here
              // from FoodRepository.currentFood by the meal
              for (final product
                  in FoodRepository.currentFood!.products[widget.meal]!)
                TableRowWidget(
                  cells: [
                    product.name,
                    '${product.amount} g',
                    '${product.calories} kcal',
                  ],
                ),
            ],
          ),
          TextWidget(
            'Lebensmittel hinzufügen',
            style: Theme.of(context).textTheme.bodyLarge,
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          ),
          // search bar
          TextFieldWidget(
            controller: searchController,
            margin: const EdgeInsets.all(20),
            onChanged: (v) {
              /// search for products, update list
              setState(() {
                filteredProducts = products
                        ?.where(
                          (element) => element.name
                              .toLowerCase()
                              .contains(v.toLowerCase()),
                        )
                        .toList() ??
                    [];
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
                  /// add product to meal
                  Navigation.push(
                    widget: UserHealthAddMealScreen(
                      meal: widget.meal,
                      product: product,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
