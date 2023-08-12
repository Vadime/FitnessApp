library utils;

import 'package:fitness_app/app.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/widgets/widgets.dart';

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
      showDragHandle: false,
      isScrollControlled: true,
      enableDrag: false,
      barrierColor: Colors.black38,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.fromLTRB(
          10,
          0,
          10,
          context.bottomInset +
              MediaQuery.of(App.navigatorKey.currentContext!)
                  .viewInsets
                  .bottom +
              10,
        ),
        child: widget,
      ),
    );
  }

  static void pushMessage({String? message}) {
    if (message == null) return;
    pushPopup(
      widget: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Message',
              style: App.navigatorKey.currentContext!.textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(message),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigation.pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  static void disableInput() => showDialog(
        context: App.navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (context) => const MyLoadingWidget(),
      );

  static void enableInput() => pop();
}
