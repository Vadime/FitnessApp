import 'package:flutter/material.dart';

extension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ThemeData get theme => Theme.of(this);
}

class FooterButton {
  final String text;
  final Function()? onPressed;

  const FooterButton({required this.text, this.onPressed});
}

class SocialButton {
  final String text;
  final Function()? onPressed;
  final Widget icon;

  const SocialButton({
    required this.text,
    required this.onPressed,
    required this.icon,
  });
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
    return Container(
      color: context.theme.cardColor,
      padding: EdgeInsets.fromLTRB(padding, padding, padding, 0),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // social buttons
                ...socials.map(
                  (e) => Padding(
                    padding: EdgeInsets.fromLTRB(padding, padding, 0, 0),
                    child: IconButton(
                      icon: e.icon,
                      onPressed: e.onPressed,
                    ),
                  ),
                ),

                const Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(padding, padding, padding, 0),
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
