import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldWidget(
      title: 'Datenschutz',
      body: Center(
        child: TextWidget(
          'Wir sind kein ernstzunehmendes Unternehmen, aber sie können uns vertrauen. Wir werden natürlich nicht Ihre Daten verkaufen. Ihre Daten sind bei uns sicher. ',
          margin: EdgeInsets.all(40),
        ),
      ),

      // ScrollViewWidget(
      //   maxInnerWidth: 600,
      //   children: [
      //     TextWidget(
      //       'Wir sind kein ernstzunehmendes Unternehmen, aber sie können uns vertrauen. Wir werden natürlich nicht Ihre Daten verkaufen. Ihre Daten sind bei uns sicher. ',
      //     ),
      //   ],
      // ),
    );
  }
}
