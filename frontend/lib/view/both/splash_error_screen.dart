import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class SplashErrorScreen extends StatelessWidget {
  const SplashErrorScreen({
    super.key,
    required this.initialisationError,
  });

  final String? initialisationError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: Stack(
        children: [
          Center(
            child: Logo(
              size: context.shortestSide / 3,
            ),
          ),
          Align(
            alignment: const Alignment(0, 3 / 4),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                initialisationError!,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
