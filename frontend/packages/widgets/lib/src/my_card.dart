import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets padding, margin;
  const MyCard({
    required this.children,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    super.key,
  });

  factory MyCard.single({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(0),
    EdgeInsets margin = const EdgeInsets.all(0),
  }) {
    return MyCard(
      padding: padding,
      margin: margin,
      children: [child],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      child: Padding(
        padding: padding,
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
