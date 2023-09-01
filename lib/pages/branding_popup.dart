import 'package:fitnessapp/pages/about_screen.dart';
import 'package:fitnessapp/pages/privacy_screen.dart';
import 'package:fitnessapp/pages/terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:widgets/widgets.dart';

class BrandingPopup extends StatelessWidget {
  const BrandingPopup({super.key});

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
        TextButtonWidget(
          'About',
          onPressed: () => Navigation.push(widget: const AboutScreen()),
        ),
        TextButtonWidget(
          'Contact',
          onPressed: () async {
            await UrlLauncher.launchEmail(
              'traumteam@email.de',
              'Angelegenheit',
            );
          },
        ),
        TextButtonWidget(
          'Privacy',
          onPressed: () => Navigation.push(widget: const PrivacyScreen()),
        ),
        TextButtonWidget(
          'Terms',
          onPressed: () => Navigation.push(widget: const TermsScreen()),
        ),
      ],
    );
  }
}
