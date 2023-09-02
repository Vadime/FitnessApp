part of 'database.dart';

class Store extends DatabaseModule {
  static final Store _instance = Store._internal();

  static firestore.FirebaseFirestore get instance =>
      firestore.FirebaseFirestore.instance;

  factory Store() => _instance;

  @override
  Future<void> init(bool useEmulator) async {
    if (useEmulator) {
      instance.useFirestoreEmulator('localhost', 8080);
    }
  }

  Store._internal();
}
