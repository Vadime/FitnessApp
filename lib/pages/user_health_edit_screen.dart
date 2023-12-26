import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/src/health.dart';
import 'package:fitnessapp/models/src/health_goal.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserHealthEditScreen extends StatefulWidget {
  const UserHealthEditScreen({
    super.key,
  });

  @override
  State<UserHealthEditScreen> createState() => _UserHealthEditScreenState();
}

class _UserHealthEditScreenState extends State<UserHealthEditScreen> {
  late final Health health;

  @override
  initState() {
    health = HealthRepository.currentHealth?.copyWith() ??
        Health.empty(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Health bearbeiten',
      body: Builder(
        builder: (context) {
          return ScrollViewWidget(
            safeArea: true,
            padding: const EdgeInsets.all(20),
            children: [
              ListTileWidget(
                title: 'Gewicht',
                titleStyle: context.textTheme.bodyLarge,
                trailing: Text(
                  '${health.weight} kg',
                  style: context.textTheme.bodyMedium,
                ),
                onTap: () {
                  Navigation.pushWeightPicker(
                    initial: health.weight,
                    onSaved: (v) {
                      setState(() {
                        health.weight = v;
                      });
                    },
                  );
                },
              ),
              ListTileWidget(
                title: 'Größe',
                titleStyle: context.textTheme.bodyLarge,
                trailing: Text(
                  '${health.height} cm',
                  style: context.textTheme.bodyMedium,
                ),
                onTap: () {
                  Navigation.pushHeightPicker(
                    initial: health.height,
                    onSaved: (v) {
                      setState(() {
                        health.height = v;
                      });
                    },
                  );
                },
              ),
              ListTileWidget(
                title: 'Geburtsdatum',
                titleStyle: context.textTheme.bodyLarge,
                trailing: Text(
                  health.birthDate.ddMMYYYY,
                  style: context.textTheme.bodyMedium,
                ),
                onTap: () {
                  Navigation.pushDatePicker(
                    initial: health.birthDate,
                    first: DateTime(1900),
                    last: DateTime.now(),
                    onChanged: (v) {
                      setState(() {
                        health.birthDate = v;
                      });
                    },
                  );
                },
              ),
              ListTileWidget(
                title: 'Geschlecht',
                titleStyle: context.textTheme.bodyLarge,
                trailing: Text(
                  health.gender.str,
                  style: context.textTheme.bodyMedium,
                ),
                onTap: () {
                  // iteriere über alle enums
                  // und erstelle eine liste mit den namen
                  var oldGender = health.gender;
                  int newIndex = (oldGender.index + 1) % Gender.values.length;
                  var newGender = Gender.values[newIndex];

                  health.gender = newGender;
                  setState(() {});
                },
              ),
              ListTileWidget(
                title: 'Fitness Ziel',
                titleStyle: context.textTheme.bodyLarge,
                trailing: Text(
                  health.goal.str,
                  style: context.textTheme.bodyMedium,
                ),
                onTap: () {
                  // iteriere über alle enums
                  // und erstelle eine liste mit den namen
                  var oldGoal = health.goal;
                  int newIndex = (oldGoal.index + 1) % HealthGoal.values.length;
                  var newGender = HealthGoal.values[newIndex];

                  health.goal = newGender;
                  setState(() {});
                },
              ),

              const SizedBox(height: 20),
              // caluclated calories text
              Text(
                'Täglich benötigte Kalorien',
                style: context.textTheme.bodyLarge,
              ),
              const SizedBox(height: 10),
              Text(
                health.bmr.toStringAsFixed(0),
                style: context.textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),

              Text(
                'Makronährstoffverteilung',
                style: context.textTheme.bodyLarge,
              ),
              const SizedBox(height: 10),

              TableWidget(
                rows: [
                  const TableRowWidget(
                    cells: [
                      'Kohlenhydrate',
                      'Fette',
                      'Eiweiß',
                    ],
                  ),
                  // makros in prozent
                  TableRowWidget(
                    cells: [
                      '${(health.carbsPercent * 100).toStringAsFixed(1)} %',
                      '${(health.fatPercent * 100).toStringAsFixed(1)} %',
                      '${(health.proteinPercent * 100).toStringAsFixed(1)} %',
                    ],
                  ),
                  // makros in gramm
                  TableRowWidget(
                    cells: [
                      '${health.carbs.toStringAsFixed(1)} g',
                      '${health.fat.toStringAsFixed(1)} g',
                      '${health.protein.toStringAsFixed(1)} g',
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 5),
              TwoTickSlider(
                startValue: health.carbsPercent,
                endValue: health.carbsPercent + health.fatPercent,
                min: 0,
                max: 1,
                minLimit: 0.2,
                maxLimit: 0.9,
                onChanged: (start, end) {
                  setState(() {
                    health.carbsPercent = start;
                    health.fatPercent = end - start;
                    health.proteinPercent = 1 - end;
                  });
                },
              ),
            ],
          );
        },
      ),
      primaryButton: ElevatedButtonWidget(
        'Speichern',
        onPressed: () async {
          // save user to firebase
          await HealthRepository.updateHealth(health);
          Navigation.flush(
            widget: const HomeScreen(
              initialIndex: 2,
            ),
          );
        },
      ),
    );
  }
}
