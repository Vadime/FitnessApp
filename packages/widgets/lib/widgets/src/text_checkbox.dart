import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class TextCheckboxWidget extends StatelessWidget {
  final CheckboxController controller;
  final Widget child;
  final bool enabled;
  final EdgeInsets? margin;
  const TextCheckboxWidget({
    required this.child,
    this.enabled = true,
    this.margin,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: margin ??
            EdgeInsets.fromLTRB(
                context.config.paddingH, context.config.paddingH, 0, 0),
        child: Row(
          children: [
            Expanded(child: child),
            SizedBox(width: context.config.padding),
            CheckboxWidget(
              controller: controller,
              enabled: enabled,
            ),
          ],
        ),
      );
}
