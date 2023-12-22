import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class PageDescription extends StatelessWidget {
  final IconData icon;
  final String text;
  const PageDescription(this.icon, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(height: 40, child: VerticalDivider(width: 40)),
          TextWidget(
            text,
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
