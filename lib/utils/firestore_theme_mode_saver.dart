import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessapp/database/database.dart';
import 'package:flutter/material.dart';
import 'package:widgets/controllers/controllers.dart';

/// This class is seperate, because it doesnt make sense to intertwine the logik for saving the thememode with the current user or database,
/// i may change the behavior later on some other logic that has nothing to do with the user or firestore

class FirestoreThemeModeSaver extends ThemeModeSaver {
  @override
  Future<ThemeMode?> load(String key) async {
    if (UserRepository.currentUser == null) return null;
    try {
      var snap = await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .get();
      return ThemeMode.values[snap.data()?[key] ?? 0];
    } catch (e, s) {
      handleException(e, s);
    }
    return null;
  }

  @override
  Future<void> save(String key, ThemeMode mode) async {
    if (UserRepository.currentUser == null) return;
    try {
      await Store.instance
          .collection('users')
          .doc(UserRepository.currentUserUID)
          .set(
        {key: mode.index},
        SetOptions(merge: true),
      );
    } catch (e, s) {
      handleException(e, s);
    }
  }
}
