library widgets;

import 'package:flutter/material.dart';

class ContentDivider extends StatelessWidget {
  final String data;
  const ContentDivider(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(child: Divider()),
            Text(data),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
