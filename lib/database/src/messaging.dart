part of 'database.dart';

Future<void> _firebaseMessagingBackgroundHandler(
    messaging.RemoteMessage message,) async {
  Logging.log('Handling a background message ${message.messageId}');
}

class Messaging {
  static Future<void> init({
    void Function(messaging.RemoteMessage message)? onMessage,
  }) async {
    try {
      await messaging.FirebaseMessaging.instance.requestPermission();
      await messaging.FirebaseMessaging.instance.getToken(
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
