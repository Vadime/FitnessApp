import 'package:fitness_app/utils/utils.dart';
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
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: context.textTheme.labelSmall!.color,
            ),
            const VerticalDivider(
              indent: 10,
              endIndent: 10,
              width: 40,
            ),
            Text(
              error,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
