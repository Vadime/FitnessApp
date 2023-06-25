import 'dart:math';

import 'package:burnfat/screens/home_screen.dart';
import 'package:burnfat/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool userIsSignedIn = Random().nextBool();
    Widget child;
    if (userIsSignedIn) {
      child = const HomeScreen();
    } else {
      child = const SignInScreen();
    }
    return MaterialApp(
      title: 'Burn Fat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: child,
    );
  }
}
