import 'package:fitnessapp/pages/about_screen.dart';
import 'package:fitnessapp/pages/privacy_screen.dart';
import 'package:fitnessapp/pages/terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:widgets/widgets.dart';

class BrandingWidget extends StatelessWidget {
  const BrandingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FooterWidget(
      socials: [
        IconButtonWidget(
          FontAwesomeIcons.instagram,
          onPressed: () {
            UrlLauncher.launchBrowser('instagram.com');
          },
          foregroundColor: Colors.pink,
        ),
        IconButtonWidget(
          FontAwesomeIcons.twitter,
          onPressed: () {
            UrlLauncher.launchBrowser('twitter.com');
          },
          foregroundColor: Colors.blue,
        ),
      ],
      buttons: [
        TextButtonWidget(
          'Über uns',
          onPressed: () => Navigation.push(widget: const AboutScreen()),
        ),
        TextButtonWidget(
          'Kontakt',
          onPressed: () {
            UrlLauncher.launchEmail(
              'traumteam@email.de',
              'Angelegenheit',
            );
          },
        ),
        TextButtonWidget(
          'Datenschutz',
          onPressed: () {
            Navigation.push(widget: const PrivacyScreen());
          },
        ),
        TextButtonWidget(
          'Nutzungsbedingungen',
          onPressed: () {
            Navigation.push(widget: const TermsScreen());
          },
        ),
      ],
    );
  }
}
