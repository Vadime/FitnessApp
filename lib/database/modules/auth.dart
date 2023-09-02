part of 'database.dart';

class Auth extends DatabaseModule {
  static final Auth _instance = Auth._internal();

  static auth.FirebaseAuth get instance => auth.FirebaseAuth.instance;

  factory Auth() => _instance;

  @override
  Future<void> init(bool useEmulator) async {
    if (useEmulator) {
      await instance.useAuthEmulator('localhost', 9099);
    }
  }

  Auth._internal();
}
