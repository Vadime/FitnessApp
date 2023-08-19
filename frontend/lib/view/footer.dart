import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/view/footer_about_screen.dart';
import 'package:fitnessapp/view/footer_privacy_screen.dart';
import 'package:fitnessapp/view/footer_terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons, FaIcon;
import 'package:url_x_launcher/url_x_launcher.dart';
import 'package:widgets/widgets.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return FooterWidget(
      commercialText: '© 2023 Traumteam',
      socials: [
        FooterSocialButtonWidget(
          text: 'Instagram',
          onPressed: () async =>
              await UrlXLauncher.launchBrowser('instagram.com'),
          icon: const FaIcon(
            FontAwesomeIcons.instagram,
            color: Colors.pink,
          ),
        ),
        FooterSocialButtonWidget(
          text: 'Twitter',
          onPressed: () async =>
              await UrlXLauncher.launchBrowser('https://twitter.com'),
          icon: const FaIcon(FontAwesomeIcons.twitter, color: Colors.blue),
        )
      ],
      buttons: [
        FooterButtonWidget(
          text: 'About',
          onPressed: () => Navigation.push(widget: const FooterAboutScreen()),
        ),
        FooterButtonWidget(
          text: 'Contact',
          onPressed: () async {
            await UrlXLauncher.launchEmail(
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
