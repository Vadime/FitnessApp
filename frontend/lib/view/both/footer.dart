import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/both/about_screen.dart';
import 'package:fitness_app/view/both/privacy_screen.dart';
import 'package:fitness_app/view/both/terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:widgets/widgets.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Footer(
      commercialText: '© 2023 Traumteam',
      socials: [
        SocialButton(
          text: 'Twitter',
          onPressed: () async => await UriLaunching.launch(
            Uri.parse('https://pornhub.com'),
          ),
          icon: const FaIcon(FontAwesomeIcons.twitter),
        )
      ],
      buttons: [
        FooterButton(
          text: 'About',
          onPressed: () => Navigation.push(widget: const AboutScreen()),
        ),
        FooterButton(
          text: 'Contact',
          onPressed: () async {
            await UriLaunching.launch(
              Uri.parse(
                'mailto:traumteam@email.de?subject=Angelegenheit',
              ),
            ).then((value) {
              if (!value) {
                Navigation.pop();
                Messaging.show(
                  message: 'Could not launch url',
                );
              }
            }).catchError((e) {
              debugPrint(e.toString());
            });
          },
        ),
        FooterButton(
          text: 'Privacy',
          onPressed: () => Navigation.push(widget: const PrivacyScreen()),
        ),
        FooterButton(
          text: 'Terms',
          onPressed: () => Navigation.push(widget: const TermsScreen()),
        ),
      ],
    );
  }
}
