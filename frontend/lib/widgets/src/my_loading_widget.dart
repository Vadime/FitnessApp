import 'package:flutter/material.dart';

class MyLoadingWidget extends StatelessWidget {
  const MyLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
