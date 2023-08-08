import 'package:flutter/material.dart';
import 'package:widgets/src/footer/footer_button.dart';
import 'package:widgets/src/footer/social_button.dart';

export 'package:widgets/src/footer/footer_button.dart';
export 'package:widgets/src/footer/social_button.dart';

extension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}

class Footer extends StatelessWidget {
  final List<FooterButton> buttons;
  final List<SocialButton> socials;
  final double padding;
  final String commercialText;

  const Footer({
    super.key,
    required this.buttons,
    required this.socials,
    required this.commercialText,
    this.padding = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 20, padding, 0),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceAround,
              children: buttons
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                      child: TextButton(
                        onPressed: e.onPressed,
                        child: Text(
                          e.text,
                          style: context.textTheme.labelMedium,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: padding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(width: padding),
                // social buttons
                ...socials.map(
                  (e) => Padding(
                    padding: EdgeInsets.fromLTRB(0, padding, 0, padding),
                    child: IconButton(
                      icon: e.icon,
                      onPressed: e.onPressed,
                    ),
                  ),
                ),

                const Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    padding,
                    padding,
                    padding,
                    2 * padding,
                  ),
                  child: Text(
                    commercialText,
                    style: context.textTheme.labelMedium!.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
