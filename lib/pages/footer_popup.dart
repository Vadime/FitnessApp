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
        IconButtonWidget(
          FontAwesomeIcons.instagram,
          onPressed: () async =>
              await UrlLauncher.launchBrowser('instagram.com'),
          foregroundColor: Colors.pink,
        ),
        IconButtonWidget(
          FontAwesomeIcons.twitter,
          onPressed: () async => await UrlLauncher.launchBrowser('twitter.com'),
          foregroundColor: Colors.blue,
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
            );
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
