library utils;

import 'package:fitness_app/app.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';

class Navigation {
  static Future<void> push({required Widget widget}) async =>
      await App.navigatorKey.currentState!
          .push(MaterialPageRoute(builder: (context) => widget));

  static Future<void> replace({required Widget widget}) async =>
      await App.navigatorKey.currentState!
          .pushReplacement(MaterialPageRoute(builder: (context) => widget));

  static Future<void> flush({required Widget widget}) async =>
      await App.navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => widget),
        (route) => false,
      );

  static void pop() => App.navigatorKey.currentState!.pop();

  static void pushPopup({required Widget widget}) async {
    await showModalBottomSheet(
      context: App.navigatorKey.currentContext!,
      backgroundColor: Colors.transparent,
      showDragHandle: true,
      isScrollControlled: true,
      enableDrag: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.fromLTRB(
          10,
          0,
          10,
          MediaQuery.of(App.navigatorKey.currentContext!).viewInsets.bottom +
              10,
        ),
        child: widget,
      ),
    );
  }
}
