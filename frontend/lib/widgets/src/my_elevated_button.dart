import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final EdgeInsets margin;
  const MyElevatedButton({
    required this.text,
    required this.onPressed,
    this.margin = const EdgeInsets.fromLTRB(0, 0, 0, 0),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
