import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldWidget(
      title: 'Über uns',
      body: Center(
        child: TextWidget(
          'Wir sind ein junges Entwicklerteam, das mit state-of-the-art Technologien an umfangreichen Projekten für Privatpersonen und Großkonzernen arbeitet. Wenn Sie mehr über uns erfahren wollen, kontaktieren Sie uns gerne unter Facebook oder schülerVZ.',
          margin: EdgeInsets.all(40),
        ),
      ),

      // ScrollViewWidget(
      //   maxInnerWidth: 600,
      //   children: [
      //     TextWidget(
      //       'Wir sind ein junges Entwicklerteam, das mit state-of-the-art Technologien an umfangreichen Projekten für Privatpersonen und Großkonzernen arbeitet. Wenn Sie mehr über uns erfahren wollen, kontaktieren Sie uns gerne unter Facebook oder schülerVZ.',
      //     ),
      //   ],
      // ),
    );
  }
}
