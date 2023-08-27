import 'package:fitnessapp/pages/footer_about_screen.dart';
import 'package:fitnessapp/pages/footer_privacy_screen.dart';
import 'package:fitnessapp/pages/footer_terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:widgets/widgets.dart';

class FooterPopup extends StatelessWidget {
  const FooterPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return FooterWidget(
      commercialText: '© 2023 Traumteam',
      socials: [
        FooterSocialButtonWidget(
          text: 'Instagram',
          onPressed: () async =>
              await UrlLauncher.launchBrowser('instagram.com'),
          icon: FontAwesomeIcons.instagram,
        ),
        FooterSocialButtonWidget(
          text: 'Twitter',
          onPressed: () async =>
              await UrlLauncher.launchBrowser('https://twitter.com'),
          icon: FontAwesomeIcons.twitter,
        ),
      ],
      buttons: [
        FooterButtonWidget(
          text: 'About',
          onPressed: () => Navigation.push(widget: const FooterAboutScreen()),
        ),
        FooterButtonWidget(
          text: 'Contact',
          onPressed: () async {
            await UrlLauncher.launchEmail(
              'traumteam@email.de',
              'Angelegenheit',
            ).then((value) {
              if (!value) {
                Navigation.pop();
              }
            }).catchError((e) {
              debugPrint(e.toString());
            });
          },
        ),
        FooterButtonWidget(
          text: 'Privacy',
          onPressed: () => Navigation.push(widget: const FooterPrivacyScreen()),
        ),
        FooterButtonWidget(
          text: 'Terms',
          onPressed: () => Navigation.push(widget: const FooterTermsScreen()),
        ),
      ],
    );
  }
}
