part of 'database.dart';

class Functions {
  static functions.FirebaseFunctions get instance =>
      functions.FirebaseFunctions.instance;

  static Future<void> init(bool useEmulator) async {
    if (useEmulator) {
      instance.useFunctionsEmulator('localhost', 5001);
    }
  }
}
