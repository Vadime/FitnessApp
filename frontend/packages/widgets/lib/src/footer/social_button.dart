import 'package:flutter/material.dart';

class SocialButton {
  final String text;
  final Function()? onPressed;
  final Widget icon;

  const SocialButton({
    required this.text,
    required this.onPressed,
    required this.icon,
  });
}
