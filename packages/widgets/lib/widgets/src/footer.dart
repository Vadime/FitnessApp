library widgets;

import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class FooterWidget extends StatelessWidget {
  final List<TextButtonWidget> buttons;
  final List<IconButtonWidget> socials;
  final String? commercialText;

  const FooterWidget({
    super.key,
    required this.buttons,
    required this.socials,
    this.commercialText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      //  mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            context.config.paddingH,
            context.config.paddingH,
            context.config.paddingH,
            context.config.paddingH,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buttons,
          ),
        ),
        const Spacer(),
        if (commercialText != null)
          TextWidget(commercialText!, style: context.textTheme.labelSmall),
        ...socials,
        SizedBox(width: context.config.paddingH),
      ],
    );
  }
}
