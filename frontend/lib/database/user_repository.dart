import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:fitness_app/models/models.dart';

class UserRepository {
  static UserRole fromString(String str) {
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
      UserRepository.fromFirebaseAuth(auth.FirebaseAuth.instance.currentUser);

  // gibt displayName zurück
  static String? get currentUserName =>
      auth.FirebaseAuth.instance.currentUser?.displayName;

  // gibt email zurück
  static String? get currentUserEmail =>
      auth.FirebaseAuth.instance.currentUser?.email;

  // gibt uid zurück
  static String? get currentUserUID =>
      auth.FirebaseAuth.instance.currentUser?.uid;

  static UserRole? _userRole;

  static UserRole? get currentUserRole => _userRole;

  // get claims
  static Future<Map<String, dynamic>> getCurrentUserClaims() async {
    var res = await auth.FirebaseAuth.instance.currentUser?.getIdTokenResult();
    return res?.claims ?? {};
  }

  // gibt die Rolle des Users zurück
  static Future<void> refreshUserRole() async {
    var claims = await getCurrentUserClaims();
    _userRole = UserRepository.fromString(claims['role']);
  }

  static Future<void> updateCurrentUserProfile({
    required String? displayName,
    required String email,
  }) async {
    await auth.FirebaseAuth.instance.currentUser?.updateEmail(email);
    await auth.FirebaseAuth.instance.currentUser
        ?.updateDisplayName(displayName);
  }
}
