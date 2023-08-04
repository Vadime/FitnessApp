// es ist ein singleton, das die Authentifizierung verwaltet mit FirebaseAuth
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:fitness_app/database/user_repository.dart';
import 'package:fitness_app/models/models.dart';

class AuthenticationRepository {
  // loggt den User ein
  static Future<auth.UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // registriert den User
  static Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async =>
      await auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          // firebase function aufrufen um user role zu setzen
          .then(
            (userCredential) =>
                FirebaseFunctions.instance.httpsCallable('addUserRole').call({
              'uid': userCredential.user!.uid,
            }),
          )
          // auf fehler von firebase function prüfen
          .then(
            (value) => (value.data['error'] != null)
                ? throw Exception(value.data['error'])
                : null,
          );

  // loggt den User aus
  static Future<void> signOut() async {
    return await auth.FirebaseAuth.instance.signOut();
  }

  // email senden, um das Passwort zurückzusetzen
  static Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    return await auth.FirebaseAuth.instance
        .sendPasswordResetEmail(email: email);
  }

  // gibt die aktuelle Authentifizierung zurück
  static Stream<User?> get authStateChanges => auth.FirebaseAuth.instance
      .authStateChanges()
      .map((user) => UserRepository.fromFirebaseAuth(user));

  static Future<List<String>> getUsersFavoriteExercises() async {
    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .get();
    List<String> favoriteExercises = [];
    (doc.data()?['favoriteExercises'] as List<dynamic>)
        .map((e) => favoriteExercises.add(e.toString()));
    return favoriteExercises;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserAsStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(UserRepository.currentUserUID)
        .snapshots();
  }
}
