library utils;

import 'package:fitness_app/app.dart';
import 'package:flutter/material.dart';

class Messaging {
  static void show({required String message}) {
    debugPrint(message);
    App.messengerKey.currentState?.hideCurrentSnackBar();
    App.messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
