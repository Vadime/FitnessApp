import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/footer_about_screen.dart';
import 'package:fitness_app/view/footer_privacy_screen.dart';
import 'package:fitness_app/view/footer_terms_screen.dart';
import 'package:fitness_app/widgets/src/my_footer_button.dart';
import 'package:fitness_app/widgets/src/my_footer_social_button.dart';
import 'package:fitness_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return MyFooter(
      commercialText: '© 2023 Traumteam',
      socials: [
        MyFutterSocialButton(
          text: 'Instagram',
          onPressed: () async => await UriLaunching.launch(
            Uri.parse('https://instagram.com'),
          ),
          icon: const FaIcon(
            FontAwesomeIcons.instagram,
            color: Colors.pink,
          ),
        ),
        MyFutterSocialButton(
          text: 'Twitter',
          onPressed: () async => await UriLaunching.launch(
            Uri.parse('https://twitter.com'),
          ),
          icon: const FaIcon(FontAwesomeIcons.twitter, color: Colors.blue),
        )
      ],
      buttons: [
        MyFooterButton(
          text: 'About',
          onPressed: () => Navigation.push(widget: const FooterAboutScreen()),
        ),
        MyFooterButton(
          text: 'Contact',
          onPressed: () async {
            await UriLaunching.launch(
              Uri.parse(
                'mailto:traumteam@email.de?subject=Angelegenheit',
              ),
            ).then((value) {
              if (!value) {
                Navigation.pop();
              }
            }).catchError((e) {
              debugPrint(e.toString());
            });
          },
        ),
        MyFooterButton(
          text: 'Privacy',
          onPressed: () => Navigation.push(widget: const FooterPrivacyScreen()),
        ),
        MyFooterButton(
          text: 'Terms',
          onPressed: () => Navigation.push(widget: const FooterTermsScreen()),
        ),
      ],
    );
  }
}
