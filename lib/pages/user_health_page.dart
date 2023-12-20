import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserHealthPage extends StatefulWidget {
  const UserHealthPage({super.key});

  @override
  State<UserHealthPage> createState() => _UserHealthPageState();
}

class _UserHealthPageState extends State<UserHealthPage> {

  @override
  Widget build(BuildContext context) {
    return ScrollViewWidget(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButtonWidget(
            'Heute',
            onPressed: () {
              /// should go down the history in firebase, when the user started
              final DateTime first =
                  DateTime.now().subtract(const Duration(days: 7));
              final DateTime last = DateTime.now().add(const Duration(days: 7));
              Navigation.pushDatePicker(
                initial: DateTime.now(),
                first: first,
                last: last,
                onChanged: (date) {
                  // need to update the day
                  setState(() {});
                },
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: context.mediaQuery.size.width / 5,
              child: headlineWidget(
                value: 1200,
                description: 'gegessen',
                context: context,
              ),
            ),
            Center(
              child: CircularProgressWidget(
                0.7,
                thickness: 10,
                margin: const EdgeInsets.all(20),
                radius: context.mediaQuery.size.width / 5,
                centerWidget: headlineWidget(
                  value: 540,
                  description: 'übrig',
                  context: context,
                ),
              ),
            ),
            SizedBox(
              width: context.mediaQuery.size.width / 5,
              child: headlineWidget(
                value: 316,
                description: 'verbrannt',
                context: context,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            makroScoreProgress(
              title: 'Kohlenhydrate',
              value: 70,
              max: 100,
              context: context,
            ),
            const SizedBox(width: 20),
            makroScoreProgress(
              title: 'Fette',
              value: 70,
              max: 100,
              context: context,
            ),
            const SizedBox(width: 20),
            makroScoreProgress(
              title: 'Eiweisse',
              value: 70,
              max: 100,
              context: context,
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Mahlzeiten mit ListTile

        mealTile(title: 'Frühstück', subtitle: '400 / 700 kcal'),
        mealTile(title: 'Mittagessen', subtitle: '400 / 700 kcal'),
        mealTile(title: 'Abendessen', subtitle: '400 / 700 kcal'),
        mealTile(
          title: 'Snacks',
          subtitle: '400 / 700 kcal',
        ),
      ],
    );
  }

  Column headlineWidget({
    double value = 0,
    String description = 'Placeholder',
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value.toInt().toString(),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          description,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }

  Expanded makroScoreProgress({
    /// Name vom Makro
    String title = 'Placeholder',

    /// Gegessene Menge vom Makro
    double value = 0,

    /// Maximale Menge vom Makro
    double max = 100,
    required BuildContext context,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 5),
          LinearProgressWidget(
            value / max,
            thickness: 5,
          ),
          const SizedBox(height: 5),
          Text(
            '${value.toInt()}/${max.toInt()} g',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }

  ListTileWidget mealTile({
    String title = 'Placeholder',
    String subtitle = 'Placeholder',
    Function()? onPressed,
  }) {
    return ListTileWidget(
      title: title,
      subtitle: subtitle,
      trailing: IconButtonWidget(
        Icons.arrow_forward_ios_rounded,
        onPressed: onPressed,
      ),
    );
  }
}
