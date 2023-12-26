import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/user_health_edit_screen.dart';
import 'package:fitnessapp/pages/user_health_meal_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

import '../database/modules/database.dart';

class UserHealthPage extends StatefulWidget {
  const UserHealthPage({super.key});

  @override
  State<UserHealthPage> createState() => _UserHealthPageState();
}

class _UserHealthPageState extends State<UserHealthPage> {
  @override
  void initState() {
    doFuturesInSequell();
    super.initState();
  }

  doFuturesInSequell() async {
    await FoodRepository.dailyUpdate();
    await changeDate(
      HealthRepository.currentHealth?.date ?? DateTime.now().dateOnly,
    );
  }

  Future changeDate(DateTime newDate) async {
    await HealthRepository.getHealthFromDate(newDate);
    await FoodRepository.getFoodFromDate(newDate);
    if (mounted) setState(() {});
  }

  String get dateForHealthText =>
      HealthRepository.currentHealth?.date.ddMMYYYY == DateTime.now().ddMMYYYY
          ? 'Heute'
          : HealthRepository.currentHealth?.date.ddMMYYYY ==
                  DateTime.now().subtract(const Duration(days: 1)).ddMMYYYY
              ? 'Gestern'
              : HealthRepository.currentHealth?.date.ddMMYYYY ?? 'Heute';

  @override
  Widget build(BuildContext context) {
    if (UserRepository.currentUser == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (HealthRepository.currentHealth == null ||
        FoodRepository.currentFood == null) {
      return ColumnWidget(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        margin: const EdgeInsets.all(20),
        safeArea: true,
        children: [
          const PageDescription(
            Icons.info_outline_rounded,
            'Du hast noch keine Health Daten',
          ),
          TextButtonWidget(
            'Health Daten hinzufügen',
            onPressed: () {
              Navigation.push(widget: const UserHealthEditScreen());
            },
          ),
        ],
      );
    }
    return ScrollViewWidget(
      safeArea: true,
      padding: const EdgeInsets.all(20),
      children: [
        // DatePicker
        Align(
          alignment: Alignment.centerLeft,
          child: TextButtonWidget(
            dateForHealthText,
            onPressed: () {
              /// should go down the history in firebase, when the user started

              Navigation.pushDatePicker(
                initial: HealthRepository.currentHealth!.date,
                first: DateTime.now().subtract(const Duration(days: 7)),
                last: DateTime.now(),
                onChanged: changeDate,
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        // Kalorien gegessen, übrig, verbrannt
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: (context.mediaQuery.size.width - 120) / 3,
              child: headlineWidget(
                value: FoodRepository.currentFood?.totalCalories,
                description: 'gegessen',
                context: context,
              ),
            ),
            const SizedBox(width: 20),
            Center(
              child: CircularProgressWidget(
                FoodRepository.currentFood!.totalCalories /
                    HealthRepository.currentHealth!.totalCalories,
                thickness: 10,
                radius: context.mediaQuery.size.width / 6,
                centerWidget: headlineWidget(
                  value: (HealthRepository.currentHealth!.totalCalories -
                          FoodRepository.currentFood!.totalCalories)
                      .abs(),
                  description: (FoodRepository.currentFood!.totalCalories /
                              HealthRepository.currentHealth!.totalCalories >
                          1)
                      ? 'überschuss'
                      : 'übrig',
                  context: context,
                ),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: (context.mediaQuery.size.width - 120) / 3,
              child: headlineWidget(
                value: 0,
                description: 'verbrannt',
                context: context,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Makro Progresse
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            makroScoreProgress(
              title: Macro.carbohydrate.str,
              value: FoodRepository.currentFood!.totalCarbs,
              max: HealthRepository.currentHealth!.carbs,
              context: context,
            ),
            const SizedBox(width: 20),
            makroScoreProgress(
              title: Macro.fat.str,
              value: FoodRepository.currentFood!.totalFat,
              max: HealthRepository.currentHealth!.fat,
              context: context,
            ),
            const SizedBox(width: 20),
            makroScoreProgress(
              title: Macro.protein.str,
              value: FoodRepository.currentFood!.totalProtein,
              max: HealthRepository.currentHealth!.protein,
              context: context,
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Mahlzeiten mit ListTile
        mealTile(
          title: MealType.breakfast.str,
          subtitle:
              '${FoodRepository.currentFood!.breakfastCalories.toInt()} / ${(HealthRepository.currentHealth!.breakfastCalories).toInt()} kcal',
          mealType: MealType.breakfast,
        ),
        mealTile(
          title: MealType.lunch.str,
          subtitle:
              '${FoodRepository.currentFood!.lunchCalories.toInt()} / ${(HealthRepository.currentHealth!.lunchCalories).toInt()} kcal',
          mealType: MealType.lunch,
        ),
        mealTile(
          title: MealType.dinner.str,
          subtitle:
              '${FoodRepository.currentFood!.dinnerCalories.toInt()} / ${(HealthRepository.currentHealth!.dinnerCalories).toInt()} kcal',
          mealType: MealType.dinner,
        ),
        mealTile(
          title: MealType.snacks.str,
          subtitle:
              '${FoodRepository.currentFood!.snacksCalories.toInt()} / ${(HealthRepository.currentHealth!.snacksCalories).toInt()} kcal',
          mealType: MealType.snacks,
        ),
      ],
    );
  }

  Column headlineWidget({
    double? value = 0,
    String description = 'Placeholder',
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (value == null)
          const LoadingWidget()
        else
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
            '${value.toInt()} / ${max.toInt()} g',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }

  ListTileWidget mealTile({
    String title = 'Placeholder',
    String subtitle = 'Placeholder',
    required MealType mealType,
  }) {
    return ListTileWidget(
      title: title,
      subtitle: subtitle,
      onTap: () {
        Navigation.push(
          widget: UserHealthMealInfoScreen(meal: mealType),
        );
      },
      leading: FutureBuilder(
        future: MealRepository.getImageForMealType(mealType),
        builder: (context, snap) => ImageWidget(
          snap.data != null ? NetworkImage(snap.data.toString()) : null,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.grey.withOpacity(0.5),
      ),
    );
  }
}
