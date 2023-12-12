import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class BrigthnessSwitchComponent extends StatelessWidget {
  const BrigthnessSwitchComponent({super.key});

  @override
  Widget build(BuildContext context) => IconButtonWidget(
        context.theme.brightness == Brightness.light
            ? Icons.light_mode_rounded
            : Icons.dark_mode_rounded,
        onPressed: () => context.theme.brightness == Brightness.light
            ? ThemeController.of(context).toggle(ThemeMode.dark)
            : ThemeController.of(context).toggle(ThemeMode.light),
      );
}
