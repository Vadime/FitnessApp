part of '../modules/database.dart';

class HealthRepository {

  static Health? _currentHealth;

  static Health? get currentHealth => _currentHealth;

  static Future<void> init() async {
    try {
      final health = await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .get()
          .then((value) => Health.fromJson(value.data()!['health']));
      _currentHealth = health;
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> updateHealth(Health health) async {
    try {
      await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .update({
        'health': health.toJson(),
      });
      _currentHealth = health;
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

}