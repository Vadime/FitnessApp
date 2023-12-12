library widgets;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgets/widgets.dart';

class CheckboxWidget extends StatelessWidget {
  final CheckboxController controller;
  final bool enabled;
  final EdgeInsets margin;

  const CheckboxWidget({
    required this.controller,
    this.enabled = true,
    this.margin = EdgeInsets.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: margin,
        child: BlocBuilder<CheckboxController, bool>(
            bloc: controller,
            builder: (context, state) {
              return Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(context.config.radius / 2)),
                ),
                value: state,
                onChanged:
                    !enabled ? null : (value) => controller.toggle(value),
              );
            }),
      );
}
