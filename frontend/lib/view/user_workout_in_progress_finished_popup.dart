import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserWorkoutInProgressFinishedPopup extends StatelessWidget {
  final Workout workout;

  const UserWorkoutInProgressFinishedPopup({
    required this.workout,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Congratulations!',
            style: context.textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          const Text('You have finished your workout! How was it?'),
          const SizedBox(height: 20),
          SegmentedButton<WorkoutDifficulty>(
            segments: WorkoutDifficulty.values
                .map(
                  (e) => ButtonSegment(
                    label: Text(e.strName),
                    value: e,
                  ),
                )
                .toList(),
            emptySelectionAllowed: true,
            selected: const {},
            multiSelectionEnabled: false,
            onSelectionChanged: (difficulties) async {
              await UserRepository.saveWorkoutStatistics(
                workout,
                difficulties.first,
              );
              Navigation.flush(widget: const HomeScreen(initialIndex: 3));
            },
          ),
        ],
      ),
    );
  }
}
