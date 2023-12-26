part of '../modules/database.dart';

class HealthRepository {
  static Health? _currentHealth;

  static Health? get currentHealth => _currentHealth;

  static Future<Health> getHealthFromDate(DateTime date) async {
    date = DateTime(date.year, date.month, date.day);
    try {
      // get health data from the given date
      final snapshot = await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .collection('health')
          .where('date', isEqualTo: firestore.Timestamp.fromDate(date))
          .get();
      var json = snapshot.docs.firstOrNull?.data();
      // if json is null, return the health of the last day
      // but change the date to the given date
      if (json == null) {
        final snapshot = await Store.instance
            .collection('users')
            .doc(UserRepository.currentUserUID)
            .collection('health')
            .orderBy('date', descending: true)
            .limit(1)
            .get();

        json = snapshot.docs.firstOrNull?.data();
      }
      // if no health data is available, return empty health
      if (json == null) {
        _currentHealth = Health.empty(date);
        return _currentHealth!;
      }
      _currentHealth = Health.fromJson(json);
      _currentHealth!.date = date;
      return _currentHealth!;
    } catch (e, s) {
      throw handleException(e, s);
    }
  }

  static Future<void> updateHealth(Health health) async {
    health.date = DateTime(
      health.date.year,
      health.date.month,
      health.date.day,
    );
    try {
      var snapshot = await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .collection('health')
          .where('date', isEqualTo: Timestamp.fromDate(health.date))
          .limit(1)
          .get();
      if (snapshot.docs.isEmpty) {
        await Store.instance
            .collection('users')
            .doc(UserRepository.currentUserUID)
            .collection('health')
            .add(health.toJson());
      } else {
        await snapshot.docs.firstOrNull?.reference.update(health.toJson());
      }

      _currentHealth = health;
    } catch (e, s) {
      throw handleException(e, s);
    }
  }
}
