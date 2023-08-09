import 'package:flutter/material.dart';

class MyFutterSocialButton {
  final String text;
  final Function()? onPressed;
  final Widget icon;

  const MyFutterSocialButton({
    required this.text,
    required this.onPressed,
    required this.icon,
  });
}
