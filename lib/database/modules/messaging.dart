part of 'database.dart';

Future<void> _firebaseMessagingBackgroundHandler(
  messaging.RemoteMessage message,
) async {
  Logging.log('Handling a background message ${message.messageId}');
}

class Messaging {
  static messaging.FirebaseMessaging get instance =>
      messaging.FirebaseMessaging.instance;

  static Future<void> init(bool useEmulator) async {
    if (useEmulator) return;
    try {
      await instance.requestPermission();
      await instance.getToken(
        vapidKey:
            'BOP3tNXjrwSmRV1CKxLxXXwVkK5MRIH9cboVCLXAN27AlsfvHdQ4B--yXmUeF8sOXRsg8Vf1P4YynehXyu2mBP8',
      );
      messaging.FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
    } catch (e, s) {
      throw handleException(e, s);
    }
  }
}
