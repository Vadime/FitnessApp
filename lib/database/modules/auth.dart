part of 'database.dart';

class Auth {
  static auth.FirebaseAuth get instance => auth.FirebaseAuth.instance;

  static Future<void> init(bool useEmulator) async {
    if (useEmulator) {
      await instance.useAuthEmulator('localhost', 9099);
    }
  }
}
