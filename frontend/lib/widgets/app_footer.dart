import 'package:fitness_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.cardColor,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceAround,
              children: [
                // about
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                  child: TextButton(
                    onPressed: () =>
                        Navigation.push(widget: const AboutScreen()),
                    child: Text(
                      'About',
                      style: context.textTheme.labelMedium,
                    ),
                  ),
                ),
                // contact
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                  child: TextButton(
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
                    child: Text(
                      'Contact',
                      style: context.textTheme.labelMedium,
                    ),
                  ),
                ),

                // privacy
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                  child: TextButton(
                    onPressed: () =>
                        Navigation.push(widget: const PrivacyScreen()),
                    child: Text(
                      'Privacy',
                      style: context.textTheme.labelMedium,
                    ),
                  ),
                ),
                // terms
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                  child: TextButton(
                    onPressed: () =>
                        Navigation.push(widget: const TermsScreen()),
                    child: Text(
                      'Terms',
                      style: context.textTheme.labelMedium,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // twitter icon
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.twitter),
                    onPressed: () async => await UriLaunching.launch(
                      Uri.parse('https://pornhub.com'),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Text(
                    '© 2023 Traum Team',
                    style: context.textTheme.labelSmall,
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

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Würdest du gerne wissen du pervert\n👍',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Wir klauen alle deine Daten\n👍',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Wir dürfen mit dir machen, was wir wollen\n👍',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
