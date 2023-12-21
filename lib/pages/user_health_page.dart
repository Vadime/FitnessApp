import 'package:fitnessapp/models/macro.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/user_health_add_meal_screen.dart';
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
    return ColumnWidget(
      safeArea: true,
      margin: const EdgeInsets.all(20),
      children: [
        const Expanded(
          child: SizedBox(height: 0),
        ),
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
              title: Macro.carbohydrate.str,
              value: 70,
              max: 100,
              context: context,
            ),
            const SizedBox(width: 20),
            makroScoreProgress(
              title: Macro.fat.str,
              value: 70,
              max: 100,
              context: context,
            ),
            const SizedBox(width: 20),
            makroScoreProgress(
              title: Macro.protein.str,
              value: 70,
              max: 100,
              context: context,
            ),
          ],
        ),
        const Expanded(
          flex: 2,
          child: SizedBox(height: 20),
        ),
        // Mahlzeiten mit ListTile

        mealTile(
          title: Meal.breakfast.str,
          subtitle: '400 / 700 kcal',
          meal: Meal.breakfast,
        ),
        mealTile(
          title: Meal.lunch.str,
          subtitle: '400 / 700 kcal',
          meal: Meal.lunch,
        ),
        mealTile(
          title: Meal.dinner.str,
          subtitle: '400 / 700 kcal',
          meal: Meal.dinner,
        ),
        mealTile(
          title: Meal.snacks.str,
          subtitle: '400 / 700 kcal',
          meal: Meal.snacks,
        ),
        const Expanded(
          child: SizedBox(height: 0),
        ),
      ],
    );
  }

  Widget mealTable({required Meal meal}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            TextWidget(
              meal.str,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Expanded(child: SizedBox(width: 20)),
            ImageWidget(
              NetworkImage(
                mealImages[meal] ?? 'https://picsum.photos/200/300',
              ),
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ],
        ),
        const SizedBox(height: 20),
        const TableWidget(
          rows: [
            TableRowWidget(
              cells: [
                'Name',
                'Menge',
                'Kalorien',
              ],
            ),
            TableRowWidget(
              cells: [
                'Apfel',
                '1',
                '100',
              ],
            ),
            TableRowWidget(
              cells: [
                'Birne',
                '1',
                '100',
              ],
            ),
            TableRowWidget(
              cells: [
                'Banane',
                '1',
                '100',
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButtonWidget(
          '${meal.str} hinzufügen',
          onPressed: () {
            Navigation.push(widget: UserHealthAddMealScreen(meal: meal));
          },
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

  Map<Meal, String> mealImages = {
    Meal.breakfast:
        'https://www.eismann.de/fileadmin/_processed_/c/1/csm_Fruehstueckorientalles800x1068_370d99660e.jpeg',
    Meal.lunch: 'https://www.koch-mit.de/app/uploads/2020/01/jaegerpfanne.jpg',
    Meal.dinner:
        'https://image.brigitte.de/10925282/t/cE/v5/w1440/r1.5/-/20-minuten-rezept.jpg',
    Meal.snacks:
        'https://www.aviko.de/_next/image?url=https%3A%2F%2Faviko-eu.s3.eu-west-2.amazonaws.com%2Fgermany%2F2023-06%2F1._einfach_umsatzstark_-_snack_gedeck.png&w=1920&q=75',
  };

  ListTileWidget mealTile({
    String title = 'Placeholder',
    String subtitle = 'Placeholder',
    Meal? meal,
  }) {
    return ListTileWidget(
      title: title,
      subtitle: subtitle,
      onTap: () {
        if (meal == null) {
          ToastController().show('Vallah Billah du hast noch nischt gefressen');
          return;
        }
        Navigation.pushPopup(
          widget: mealTable(meal: meal),
        );
      },
      leading: ImageWidget(
        NetworkImage(
          mealImages[meal] ?? 'https://picsum.photos/200/300',
        ),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.grey.shade300,
      ),
    );
  }
}
