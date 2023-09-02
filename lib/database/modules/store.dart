part of 'database.dart';

class Store {
  static firestore.FirebaseFirestore get instance =>
      firestore.FirebaseFirestore.instance;

  static Future<void> init(bool useEmulator) async {
    if (useEmulator) {
      instance.useFirestoreEmulator('localhost', 8080);
    }
  }
}
