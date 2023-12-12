library app_storage;

import 'package:shared_preferences/shared_preferences.dart';

/// This package is used to store data in the device's local storage
/// It uses the Shared Preferences package
/// https://pub.dev/packages/shared_preferences
/// It uses the NoviStorage class to store and retrieve data
class LocalStorage {
  SharedPreferences? _prefs;

  Future<void> _init() async =>
      _prefs ??= await SharedPreferences.getInstance();

  Future<String?> getString(String key) async {
    await _init();
    return _prefs?.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    await _init();
    return _prefs?.setString(key, value) ?? Future.value(false);
  }

  Future<int?> getInt(String key) async {
    await _init();
    return _prefs?.getInt(key);
  }

  Future<bool> setInt(String key, int value) async {
    await _init();
    return _prefs?.setInt(key, value) ?? Future.value(false);
  }
}
