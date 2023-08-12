import 'package:fitness_app/widgets/src/my_footer_button.dart';
import 'package:fitness_app/widgets/src/my_footer_social_button.dart';
import 'package:flutter/material.dart';

class MyFooter extends StatelessWidget {
  final List<MyFooterButton> buttons;
  final List<MyFutterSocialButton> socials;
  final double padding;
  final String commercialText;

  const MyFooter({
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
                        style: Theme.of(context).textTheme.labelMedium,
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
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
