part of 'database.dart';

extension on String {
  String log(e, s) {
    Logging.logDetails(this, e, s);
    return this;
  }
}

String handleException(Object? e, [StackTrace? s]) {
  if (e is String) {
    return e.log(e, s);
  } else if (e is auth.FirebaseAuthException) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email'.log(e, s);
      case 'wrong-password':
        return 'Wrong password'.log(e, s);
      case 'user-not-found':
        return 'Account not found'.log(e, s);
      case 'user-disabled':
        return 'Account disabled'.log(e, s);
      case 'too-many-requests':
        return 'Too many requests. Try again later'.log(e, s);
      case 'operation-not-allowed':
        return 'Operation not allowed'.log(e, s);
      case 'email-already-in-use':
        return 'Email already in use'.log(e, s);
      case 'weak-password':
        return 'Weak password'.log(e, s);
      case 'invalid-phone-number':
        return 'Invalid phonenumber'.log(e, s);
      case 'invalid-verification-code':
        return 'Invalid verification code'.log(e, s);
      case 'network-request-failed':
        return 'Network error'.log(e, s);
      case 'credential-already-in-use':
        return 'Account already in use'.log(e, s);
      default:
        return 'Something went wrong'.log(e, s);
    }
  } else if (e is core.FirebaseException) {
    switch (e.code) {
      case 'permission-denied':
        return 'Permission denied'.log(e, s);
      case 'unavailable':
        return 'Unavailable'.log(e, s);
      case 'cancelled':
        return 'Cancelled'.log(e, s);
      case 'unknown':
        return 'Something went wrong'.log(e, s);
      default:
        return 'Something went wrong'.log(e, s);
    }
  } else {
    return 'Something went wrong'.log(e, s);
  }
}
