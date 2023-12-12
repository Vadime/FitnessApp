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
    return LayoutBuilder(
      builder: (BuildContext c, BoxConstraints cnstrnts) {
        if (cnstrnts.maxWidth > 360) {
          return landscapeBuilder(c);
        } else {
          return portraitBuilder(c);
        }
      },
    );
  }

  landscapeBuilder(BuildContext context) => Row(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        //  mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.config.paddingH,
              context.config.paddingH,
              context.config.paddingH,
              context.config.paddingH,
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              spacing: 4,
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

  portraitBuilder(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.config.paddingH,
              context.config.padding,
              context.config.paddingH,
              context.config.paddingH,
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              spacing: 4,
              children: buttons,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.config.paddingH,
              0, //context.config.paddingH,
              context.config.paddingH,
              context.config.paddingH,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ...socials,
                const Spacer(),
                if (commercialText != null)
                  TextWidget(commercialText!,
                      style: context.textTheme.labelSmall),
              ],
            ),
          ),
        ],
      );
}
