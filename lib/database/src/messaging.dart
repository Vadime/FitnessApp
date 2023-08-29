import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:widgets/utils/logging.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Logging.log('Handling a background message ${message.messageId}');
}

class Messaging {
  static Future<void> init({
    void Function(RemoteMessage message)? onMessage,
  }) async {
    await requestPermission();
    await getToken();

    // INIT FOREGROUND MESSAGES
    Messaging.onMessage((RemoteMessage message) {
      Logging.log('Got a message whilst in the foreground!');
      Logging.log('Message data: ${message.data}');

      if (message.notification != null) {
        Logging.log(
          'Message also contained a notification: ${message.notification}',
        );
      }
      onMessage?.call(message);
    });

    Messaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<String?> getToken() async {
    return await messaging.getToken(
      vapidKey:
          'BOP3tNXjrwSmRV1CKxLxXXwVkK5MRIH9cboVCLXAN27AlsfvHdQ4B--yXmUeF8sOXRsg8Vf1P4YynehXyu2mBP8',
    );
  }

  static Future<void> deleteToken() async {
    await messaging.deleteToken();
  }

  static Future<void> requestPermission() async {
    await messaging.requestPermission();
  }

  static Future<void> onMessage(
    void Function(RemoteMessage message) onMessage,
  ) async {
    FirebaseMessaging.onMessage.listen(onMessage);
  }

  static Future<void> onMessageOpenedApp(
    void Function(RemoteMessage message) onMessageOpenedApp,
  ) async {
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
  }

  static Future<void> onBackgroundMessage(
    Future<void> Function(RemoteMessage message) onBackgroundMessage,
  ) async {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  }
}
