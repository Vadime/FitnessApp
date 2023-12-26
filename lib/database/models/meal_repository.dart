part of '../modules/database.dart';

// get images from firebase storage
// for every MealType
class MealRepository {
  static Future<String> getImageForMealType(MealType mealType) async {
    try {
      final storage.ListResult result =
          await Storage.instance.ref('meals').listAll();
      final String name = mealType.toString().split('.').last;

      for (final storage.Reference ref in result.items) {
        if (ref.name.startsWith(name)) {
          return await ref.getDownloadURL();
        }
      }

      throw Exception('Keine Datei gefunden');
    } catch (e, s) {
      throw handleException(e, s);
    }
  }
}
