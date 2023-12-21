part of '../modules/database.dart';

class MessageRepository {
  static Future<List<Message>> get messagesAsFuture async =>
      (await Store.instance
              .collection('users')
              .doc(UserRepository.currentUser!.uid)
              .collection('messages')
              .orderBy('timestamp', descending: false)
              .get())
          .docs
          .map((e) => Message.fromJson(e.id, e.data()))
          .toList();

  static Future<void> uploadMessage(Message message) async {
    try {
      await Store.instance
          .collection('users')
          .doc(UserRepository.currentUser!.uid)
          .collection('messages')
          .add(message.toJson());
    } catch (e, s) {
      throw handleException(e, s);
    }
  }
}
