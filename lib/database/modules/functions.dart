part of 'database.dart';

class Functions extends DatabaseModule {
  static final Functions _instance = Functions._internal();

  static functions.FirebaseFunctions get instance =>
      functions.FirebaseFunctions.instance;

  factory Functions() => _instance;

  @override
  Future<void> init(bool useEmulator) async {
    if (useEmulator) {
      instance.useFunctionsEmulator('localhost', 5001);
    }
  }

  Functions._internal();
}
