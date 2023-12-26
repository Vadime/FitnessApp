part of '../modules/database.dart';

/// a repository for the food collection
/// contains all the methods to interact with the food collection
/// in the firestore database
/// also for adding meals, updating meals and deleting meals
/// because meals are stored in a food object
class FoodRepository {
  static Food? _currentFood;

  static Food? get currentFood => _currentFood;

  // check for latest food data
  // if today is a new day (not in collection), then i need to create a new document
  // if today is not a new day, then i need to get the document
  static Future<Food> dailyUpdate() async {
    DateTime today = DateTime.now().dateOnly;

    final snapshot = await Store.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .collection('food')
        .where('date', isEqualTo: Timestamp.fromDate(today))
        .get();

    var json = snapshot.docs.firstOrNull?.data();
    // there is no food document for today
    if (json == null) {
      // we need to create one
      _currentFood = Food.empty(today);
      await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .collection('food')
          .add(Food.empty(today).toJson());
      return _currentFood!;
    } else {
      // there is a food document for today
      _currentFood = Food.fromJson(json);
      return _currentFood!;
    }
  }

  static Future<Food> getFoodFromDate(DateTime date) async {
    try {
      /// we need this to be able to switch between days dynamically
      final snapshot = await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .collection('food')
          .where('date', isEqualTo: Timestamp.fromDate(date.dateOnly))
          .get();
      var json = snapshot.docs.firstOrNull?.data();
      // Logging.log('FOOD_____${date.dateOnly}');
      // Logging.log('$json');

      // if json is null, return the food of the last day
      // but change the date to the given date
      if (json == null) {
        final snapshot = await Store.instance
            .collection('users')
            .doc(UserRepository.currentUserUID)
            .collection('food')
            .orderBy('date', descending: true)
            .limit(1)
            .get();

        json = snapshot.docs.firstOrNull?.data();
      }
      // if no food data is available, return empty food
      if (json == null) {
        _currentFood = Food.empty(date);
        return _currentFood!;
      }
      _currentFood = Food.fromJson(json);
      _currentFood!.date = date;
      return _currentFood!;
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  // add a product to a meal of the current food
  static Future<void> addProductToMeal(
    Product product,
    MealType mealType,
  ) async {
    try {
      _currentFood ??= Food.empty(DateTime.now());
      _currentFood!.products[mealType]!.add(product);
      // get the current food from the database
      var snapshot = await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .collection('food')
          .where('date', isEqualTo: Timestamp.fromDate(_currentFood!.date))
          .limit(1)
          .get();
      // if the food does not exist, add it to the database
      if (snapshot.docs.isEmpty) {
        await Store.instance
            .collection('users')
            .doc(UserRepository.currentUserUID)
            .collection('food')
            .add(_currentFood!.toJson());
      } else {
        // if the food exists, update it
        await snapshot.docs.first.reference.update(_currentFood!.toJson());
      }
    } catch (e, s) {
      throw handleException(e, s);
    }
  }
}
