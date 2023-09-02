part of 'database.dart';

class Storage extends DatabaseModule {
  static final Storage _instance = Storage._internal();

  static storage.FirebaseStorage get instance =>
      storage.FirebaseStorage.instance;

  factory Storage() => _instance;

  @override
  Future<void> init(bool useEmulator) async {
    if (useEmulator) {
      await instance.useStorageEmulator('localhost', 9199);
    }
  }

  Storage._internal();
}
