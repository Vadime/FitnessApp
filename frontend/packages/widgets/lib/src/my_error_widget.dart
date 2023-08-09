import 'package:flutter/material.dart';

class MyErrorWidget extends StatelessWidget {
  final String error;
  const MyErrorWidget({
    this.error = 'Loading...',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error + '\n😢',
        style: Theme.of(context).textTheme.labelSmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}
