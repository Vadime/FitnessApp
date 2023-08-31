part of 'database.dart';

extension on String {
  String log(e, s) {
    Logging.logDetails(this, e, s);
    return this;
  }
}

String handleException(Object? e, [StackTrace? s]) {
  if (e is String) {
    return e;
  } else if (e is auth.FirebaseAuthException) {
    switch (e.code) {
      case 'invalid-email':
        return 'Die E-Mail-Adresse ist ungültig.'.log(e, s);
      case 'wrong-password':
        return 'Das Passwort ist falsch.'.log(e, s);
      case 'user-not-found':
        return 'Es wurde kein Benutzer mit dieser E-Mail-Adresse gefunden.'
            .log(e, s);
      case 'user-disabled':
        return 'Dieser Benutzer wurde deaktiviert.'.log(e, s);
      case 'too-many-requests':
        return 'Zu viele Anfragen. Versuchen Sie es später erneut.'.log(e, s);
      case 'operation-not-allowed':
        return 'Diese Operation ist nicht erlaubt.'.log(e, s);
      case 'email-already-in-use':
        return 'Es existiert bereits ein Benutzer mit dieser E-Mail-Adresse.'
            .log(e, s);
      case 'weak-password':
        return 'Das Passwort ist zu schwach.'.log(e, s);
      case 'invalid-phone-number':
        return 'Die Telefonnummer ist ungültig.'.log(e, s);
      case 'invalid-verification-code':
        return 'Der Verifizierungscode ist ungültig.'.log(e, s);
      case 'network-request-failed':
        return 'Netzwerkfehler. Versuchen Sie es später erneut.'.log(e, s);
      default:
        return 'Ein unbekannter Fehler ist aufgetreten.'.log(e, s);
    }
  } else if (e is core.FirebaseException) {
    switch (e.code) {
      case 'permission-denied':
        return 'Keine Berechtigung.'.log(e, s);
      case 'unavailable':
        return 'Nicht verfügbar.'.log(e, s);
      case 'cancelled':
        return 'Abgebrochen.'.log(e, s);
      case 'unknown':
        return 'Ein unbekannter Fehler ist aufgetreten.'.log(e, s);
      default:
        return 'Ein unbekannter Fehler ist aufgetreten.'.log(e, s);
    }
  } else {
    return 'Something went wrong'.log(e, s);
  }
}
