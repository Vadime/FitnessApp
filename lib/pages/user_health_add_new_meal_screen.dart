import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:fitnessapp/widgets/upload_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgets/widgets.dart';

class UserHealthAddNewMealScreen extends StatefulWidget {
  final MealType meal;
  final String searchName;
  const UserHealthAddNewMealScreen({
    required this.meal,
    required this.searchName,
    super.key,
  });

  @override
  State<UserHealthAddNewMealScreen> createState() =>
      _UserHealthAddNewMealScreenState();
}

class _UserHealthAddNewMealScreenState
    extends State<UserHealthAddNewMealScreen> {
  late final TextFieldController nameController;
  Uint8List? imageFile;
  ValueNotifier<double> calories = ValueNotifier(100);
  ValueNotifier<double> carbs = ValueNotifier(50);
  ValueNotifier<double> protein = ValueNotifier(30);
  ValueNotifier<double> fat = ValueNotifier(20);
  ValueNotifier<double> amount = ValueNotifier(100);

  @override
  void initState() {
    nameController = TextFieldController.name(
      text: widget.searchName,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Neues Lebensmittel',
      body: ScrollViewWidget(
        children: [
          UploadFile(
            imageFile: imageFile,
            onChanged: (file) {
              imageFile = file;
              setState(() {});
            },
          ),
          const SizedBox(height: 20),
          TextFieldWidget(
            controller: nameController,
          ),
          const SizedBox(height: 20),
          CardWidget(
            padding: const EdgeInsets.all(20),
            children: [
              slider(
                title: 'Kohlenhydrate',
                value: carbs,
                unit: 'g',
                min: 0,
                max: amount.value,
              ),
              const SizedBox(height: 10),
              slider(
                title: 'Protein',
                value: protein,
                unit: 'g',
                min: 0,
                max: amount.value,
              ),
              const SizedBox(height: 10),
              slider(
                title: 'Fett',
                value: fat,
                unit: 'g',
                min: 0,
                max: amount.value,
              ),
            ],
          ),
          const SizedBox(height: 20),
          CardWidget(
            padding: const EdgeInsets.all(20),
            children: [
              slider(
                title: 'Menge',
                value: amount,
                unit: 'g',
                min: 0,
                max: 1000,
              ),
            ],
          ),
        ],
      ),
      primaryButton: ElevatedButtonWidget(
        'Zum ${widget.meal.str} hinzufügen',
        onPressed: () async {
          // upload image to firebase storage
          // get image download url
          // save it in the product
          // but for now we will leave it blank
          var p = Product(
            name: nameController.text,
            calories: calories.value,
            carbs: carbs.value,
            protein: protein.value,
            fat: fat.value,
            amount: amount.value,
          );

          ProductRepository.addProduct(p);

          // everything done, go back to home screen
          Navigation.flush(
            widget: const HomeScreen(
              initialIndex: 2,
            ),
          );
        },
      ),
    );
  }

  Widget slider({
    required String title,
    required ValueNotifier<double> value,
    required String unit,
    double min = 0,
    double max = 1000,
  }) {
    if (value.value > max) value.value = max;
    return Column(
      children: [
        Row(
          children: [
            TextWidget(
              title,
            ),
            const Expanded(
              child: SizedBox(width: 20),
            ),
            TextWidget(
              '${value.value} $unit',
            ),
          ],
        ),
        Slider(
          min: min,
          max: max,
          divisions: 50,
          value: value.value,
          label: '${value.value.round()}',
          onChanged: (newValue) {
            setState(() {
              value.value = newValue;
            });
          },
        ),
        Row(
          children: [
            TextWidget(
              '$min g',
              color: Colors.grey.withOpacity(0.5),
            ),
            const Expanded(
              child: SizedBox(width: 20),
            ),
            TextWidget(
              '$max g',
              color: Colors.grey.withOpacity(0.5),
            ),
          ],
        ),
      ],
    );
  }
}
