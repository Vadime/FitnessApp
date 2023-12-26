part of '../modules/database.dart';

// get images from firebase storage
// for every MealType
class ProductRepository {
  static List<Product> products = [
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
    Product(
      name: 'Schokolade',
      imageUrl: 'https://www.vegpool.de/magazin/images/2019-08/apfel-rot.jpg',
      calories: 100,
      carbs: 10,
      protein: 10,
      fat: 10,
      amount: 100,
    ),
    Product(
      name: 'Pizza',
      imageUrl: 'https://www.vegpool.de/magazin/images/2019-08/apfel-rot.jpg',
      calories: 100,
      carbs: 10,
      protein: 10,
      fat: 10,
      amount: 100,
    ),
  ];

  // add a product to products
  static Future<void> addProduct(Product product) async {
    products.add(product);
  }

  /////// OpenFoodFacts integration starts here
  ///////
  ///////
  ///////
  ///////

  /// request a product from the OpenFoodFacts database
  Future<Product?> getProduct() async {
    var barcode = '0048151623426';

    final openfoodfacts.ProductQueryConfiguration configuration =
        openfoodfacts.ProductQueryConfiguration(
      barcode,
      language: openfoodfacts.OpenFoodFactsLanguage.GERMAN,
      fields: [openfoodfacts.ProductField.ALL],
      version: openfoodfacts.ProductQueryVersion.v3,
    );
    final openfoodfacts.ProductResultV3 result =
        await openfoodfacts.OpenFoodAPIClient.getProductV3(configuration);

    if (result.status == openfoodfacts.ProductResultV3.statusSuccess) {
      return productFromOpenFoodProduct(result.product);
    } else {
      throw Exception('product not found, please insert data for $barcode');
    }
  }

  Product productFromOpenFoodProduct(openfoodfacts.Product? product) => Product(
        name: product?.productName ?? 'Unknown',
        imageUrl: product?.images?.first.url ?? '',
        calories: 0,
        carbs: 0,
        protein: 0,
        fat: 0,
        amount: 0,
      );
}
