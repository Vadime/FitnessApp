import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:widgets/widgets.dart';

enum ThirdPartyLoginType { phone, google, apple }

extension ThirdPartyLoginTypeExtension on ThirdPartyLoginType {
  String get text {
    switch (this) {
      case ThirdPartyLoginType.phone:
        return 'Sign in with Phone';
      case ThirdPartyLoginType.google:
        return 'Sign In with Google';
      case ThirdPartyLoginType.apple:
        return 'Sign In with Apple';
    }
  }

  Widget get icon {
    switch (this) {
      case ThirdPartyLoginType.phone:
        return const Icon(Icons.phone_rounded);
      case ThirdPartyLoginType.google:
        return const Padding(
          padding: EdgeInsets.all(4),
          child: Icon(FontAwesomeIcons.google, size: 16),
        );
      case ThirdPartyLoginType.apple:
        return const Icon(Icons.apple_rounded);
    }
  }

  Color get color {
    switch (this) {
      case ThirdPartyLoginType.phone:
        return Colors.orange;
      case ThirdPartyLoginType.google:
        return Colors.blue;
      case ThirdPartyLoginType.apple:
        return Colors.black;
    }
  }
}

class ThirdPartyLoginButton extends StatelessWidget {
  final Function()? onPressed;
  final ThirdPartyLoginType type;
  const ThirdPartyLoginButton(this.type, {this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(context.config.paddingH,
          context.config.paddingH, context.config.paddingH, 0),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: type.color,
            padding: EdgeInsets.symmetric(
                vertical: context.config.paddingH,
                horizontal: context.config.padding),
          ),
          child: Row(
            children: [
              TextWidget(type.text),
              const Spacer(),
              type.icon,
            ],
          )),
    );
  }
}
