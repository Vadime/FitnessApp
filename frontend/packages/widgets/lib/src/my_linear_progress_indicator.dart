import 'package:flutter/material.dart';

class MyLinearProgressIndicator extends StatelessWidget {
  final double progress;
  const MyLinearProgressIndicator({required this.progress, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        tween: Tween<double>(
          begin: 0,
          end: progress,
        ),
        builder: (context, value, _) => LinearProgressIndicator(
          value: value,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
