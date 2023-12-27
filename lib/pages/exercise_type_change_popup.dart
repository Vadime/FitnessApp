import 'package:fitnessapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:widgets/widgets.dart';

class ExerciseTypeChangePopup extends StatefulWidget {
  final WorkoutExerciseType type;
  final Function(Function()) parentState;
  final Function(WorkoutExerciseType) onTypeChanged;
  const ExerciseTypeChangePopup({
    required this.type,
    required this.parentState,
    required this.onTypeChanged,
    super.key,
  });

  @override
  State<ExerciseTypeChangePopup> createState() =>
      _ExerciseTypeChangePopupState();
}

class _ExerciseTypeChangePopupState extends State<ExerciseTypeChangePopup> {
  late WorkoutExerciseType type;

  @override
  void initState() {
    type = widget.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextWidget(
              '${type.name} Exercise -',
              style: context.textTheme.labelMedium,
            ),
            TextButtonWidget(
              'Ändern',
              onPressed: () {
                WorkoutExerciseType newType;
                if (type is WorkoutExerciseTypeDuration) {
                  newType = WorkoutExerciseTypeRepetition.empty();
                } else if (type is WorkoutExerciseTypeRepetition) {
                  newType = WorkoutExerciseTypeCardio.empty();
                } else if (type is WorkoutExerciseTypeCardio) {
                  newType = WorkoutExerciseTypeDuration.empty();
                } else {
                  throw Exception('Unknown type');
                }

                type = newType;
                widget.onTypeChanged(newType);

                widget.parentState(() {});
                setState(() {});
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (type is WorkoutExerciseTypeCardio)
          Center(
            child: CardWidget(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text('Minutes'),
                NumberPicker(
                  minValue: 1,
                  maxValue: 120,
                  value: int.parse(type.values['Minutes'] ?? '10'),
                  textMapper: (value) => '$value min',
                  onChanged: (newValue) {
                    type.values['Minutes'] = newValue.toString();
                    setState(() {});
                    widget.parentState(() {});
                  },
                ),
              ],
            ),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: CardWidget(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const Text('Sets'),
                    NumberPicker(
                      minValue: 0,
                      maxValue: 10,
                      value: int.parse(type.values['Sets'] ?? '0'),
                      textMapper: (value) => value,
                      onChanged: (newValue) {
                        type.values['Sets'] = newValue.toString();
                        setState(() {});
                        widget.parentState(() {});
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              if (type is WorkoutExerciseTypeRepetition)
                Expanded(
                  child: CardWidget(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const Text('Reps'),
                      NumberPicker(
                        minValue: 0,
                        maxValue: 50,
                        value: int.parse(type.values['Reps'] ?? '0'),
                        textMapper: (value) => value,
                        onChanged: (newValue) {
                          type.values['Reps'] = newValue.toString();
                          setState(() {});
                          widget.parentState(() {});
                        },
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: CardWidget(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const Text('Seconds'),
                      NumberPicker(
                        minValue: 0,
                        maxValue: 480,
                        value: int.parse(type.values['Seconds'] ?? '0'),
                        textMapper: (value) => value,
                        onChanged: (newValue) {
                          type.values['Seconds'] = newValue.toString();
                          setState(() {});
                          widget.parentState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 20),
              Expanded(
                child: CardWidget(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const Text('Weights'),
                    NumberPicker(
                      minValue: 0,
                      maxValue: 500,
                      value: int.parse(type.values['Weights'] ?? '0'),
                      textMapper: (v) => '$v kg',
                      onChanged: (newValue) {
                        type.values['Weights'] = newValue.toString();
                        setState(() {});
                        widget.parentState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        const SizedBox(height: 20),
        ElevatedButtonWidget(
          'Auswählen',
          onPressed: () {
            Navigation.pop();
          },
        ),
      ],
    );
  }
}
