part of 'database.dart';

class Storage {
  static storage.FirebaseStorage get instance =>
      storage.FirebaseStorage.instance;

  static Future<void> init(bool useEmulator) async {
    if (useEmulator) {
      await instance.useStorageEmulator('localhost', 9199);
    }
  }
}
