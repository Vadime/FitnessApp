import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => LoadingWidgetState();
}

class LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator.adaptive());
}
