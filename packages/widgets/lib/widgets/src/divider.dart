import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class DividerWidget extends StatelessWidget {
  final String data;
  final double? verticalPadding;
  final double? outerHorizontalPadding;
  final double? innerHorizontalPadding;

  const DividerWidget(
    this.data, {
    this.verticalPadding,
    this.outerHorizontalPadding,
    this.innerHorizontalPadding,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SizedBox(height: verticalPadding ?? context.config.paddingH),
          Row(
            children: [
              SizedBox(width: outerHorizontalPadding ?? context.config.padding),
              const Expanded(
                  child: Divider(
                thickness: 2,
              )),
              SizedBox(
                  width: innerHorizontalPadding ?? context.config.paddingH),
              TextWidget(
                data,
                style: context.textTheme.labelMedium,
              ),
              SizedBox(
                  width: innerHorizontalPadding ?? context.config.paddingH),
              const Expanded(
                  child: Divider(
                thickness: 2,
              )),
              SizedBox(width: outerHorizontalPadding ?? context.config.padding),
            ],
          ),
          SizedBox(height: verticalPadding ?? context.config.paddingH),
        ],
      );
}
