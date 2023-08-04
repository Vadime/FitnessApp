import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:cloud_functions/cloud_functions.dart' as functions;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/src/logging.dart';

class UserRepository {
  static auth.FirebaseAuth get _authInstance => auth.FirebaseAuth.instance;

  static firestore.FirebaseFirestore get _storeInstance =>
      firestore.FirebaseFirestore.instance;

  static functions.FirebaseFunctions get _functionsInstance =>
      functions.FirebaseFunctions.instance;

  static storage.FirebaseStorage get _storageInstance =>
      storage.FirebaseStorage.instance;

  // loggt den User ein
  static Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Logging.log('Versucht Sign In');
    } catch (e) {
      throw e.toString().split('] ').last;
    }

    return currentUser;
  }

  // registriert den User
  static Future<User?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      var cred = await _authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // firebase function aufrufen um user role zu setzen
      var value = await _functionsInstance.httpsCallable('addUserRole').call({
        'uid': cred.user!.uid,
      });
      // auf fehler von firebase function prüfen
      if (value.data['error'] != null) throw Exception(value.data['error']);
      Logging.log('Versucht Sign Up');
    } catch (e) {
      throw e.toString().split('] ').last;
    }
    return currentUser;
  }

  // email senden, um das Passwort zurückzusetzen
  static Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      return await _authInstance.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e.toString().split('] ').last;
    }
  }

  // gibt die aktuelle Authentifizierung zurück
  static Stream<User?> get authStateChanges =>
      auth.FirebaseAuth.instance.authStateChanges().map((user) {
        if (user != null) {
          FirebaseCrashlytics.instance.setUserIdentifier(user.uid);
        }

        return UserRepository.fromFirebaseAuth(user);
      });

  // macht die role zum lesbaren String
  static UserRole roleFromString(String? str) {
    switch (str) {
      case 'Admin':
        return UserRole.admin;
      case 'admin':
        return UserRole.admin;
      case 'User':
        return UserRole.user;
      case 'user':
        return UserRole.user;
      default:
        return UserRole.user;
    }
  }

  // from firebaseauth
  static User? fromFirebaseAuth(auth.User? user) {
    if (user == null) {
      return null;
    }
    return User(
      uid: user.uid,
      email: user.email ?? '-',
      displayName: user.displayName ?? '-',
      userRole: UserRole.user,
      imageURL: user.photoURL,
    );
  }

  // gibt den aktuellen User zurück
  static User? get currentUser =>
      UserRepository.fromFirebaseAuth(_authInstance.currentUser);

  // gibt displayName zurück
  static String? get currentUserName => _authInstance.currentUser?.displayName;

  // gibt email zurück
  static String? get currentUserEmail => _authInstance.currentUser?.email;

  // gibt uid zurück
  static String? get currentUserUID => _authInstance.currentUser?.uid;

  static UserRole? _userRole;

  static UserRole? get currentUserRole => _userRole;

  static String? get currentUserImageURL => _authInstance.currentUser?.photoURL;

  // get claims
  static Future<Map<String, dynamic>> getCurrentUserClaims() async {
    var res = await _authInstance.currentUser?.getIdTokenResult();
    return res?.claims ?? {};
  }

  // gibt die Rolle des Users zurück
  static Future<void> refreshUserRole() async {
    var claims = await getCurrentUserClaims();
    _userRole = roleFromString(claims['role']);
  }

  // aktualisiert den displayName und die email
  static Future<void> updateCurrentUserProfile({
    required String? displayName,
    required String email,
  }) async {
    try {
      await _authInstance.currentUser?.updateEmail(email);
      await _authInstance.currentUser?.updateDisplayName(displayName);
    } catch (e) {
      throw e.toString().split('] ').last;
    }
  }

  // aktualisiert imageURL
  static Future<void> updateCurrentUserImage({
    required File image,
  }) async {
    try {
      String imageRef = 'user/${_authInstance.currentUser?.uid}/profileImage';
      var snapshot = await _storageInstance.ref(imageRef).putFile(image);
      var imageURL = await snapshot.ref.getDownloadURL();
      await _authInstance.currentUser?.updatePhotoURL(imageURL);
    } catch (e) {
      throw e.toString().split('] ').last;
    }
  }

  // loggt den User aus
  static Future<void> signOutCurrentUser() async =>
      await _authInstance.signOut();

  static Stream<List<String>> get currentUserFavoriteExercises =>
      _storeInstance.collection('users').doc(currentUserUID).snapshots().map(
            (event) => (event.data()?['favoriteExercises'] as List<dynamic>)
                .map((e) => e.toString())
                .toList(),
          );
}
