import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class DescriptionWidget extends StatelessWidget {
  final IconData iconData;
  final String desc;
  final EdgeInsets? padding;
  const DescriptionWidget(this.iconData, this.desc, {this.padding, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ??
            EdgeInsets.fromLTRB(
                context.config.paddingD,
                context.config.paddingH,
                context.config.paddingD,
                context.config.paddingH),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(iconData, color: Colors.grey),
          SizedBox(
              height: context.config.paddingD,
              child: VerticalDivider(
                  thickness: 2,
                  width: context.config.paddingD,
                  color: context.config.neutralColor)),
          Flexible(
              child: TextWidget(desc,
                  style: context.textTheme.bodyMedium!
                      .copyWith(color: Colors.grey))),
        ]),
      ),
    );
  }
}
