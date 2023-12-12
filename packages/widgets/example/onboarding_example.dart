import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

void main(List<String> args) {
  runApp(const MaterialApp(
      home: OnboardingPage(views: [
    OnboardingView(
        title: 'Hello',
        description: 'I love coffee',
        image: 'res/example.png',
        backgroundColor: Colors.red,
        foregroundColor: Colors.white),
    OnboardingView(
        title: 'Hello',
        description: 'I love coffee',
        image: 'res/example.png',
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white),
    OnboardingView(
        title: 'Hello',
        description: 'I love coffee',
        image: 'res/example.png',
        backgroundColor: Colors.green,
        foregroundColor: Colors.white),
  ])));
}
