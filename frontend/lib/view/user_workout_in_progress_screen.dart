import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/user_workout_in_progress_exercise_page.dart';
import 'package:fitness_app/view/user_workout_in_progress_finished_popup.dart';
import 'package:flutter/material.dart';

class UserWorkoutInProgressScreen extends StatefulWidget {
  final Workout workout;

  const UserWorkoutInProgressScreen({
    required this.workout,
    super.key,
  });

  @override
  State<UserWorkoutInProgressScreen> createState() =>
      _UserWorkoutInProgressScreenState();
}

class _UserWorkoutInProgressScreenState
    extends State<UserWorkoutInProgressScreen> {
  PageController pageController = PageController();

  // get index of current page
  int currentPageIndex = 0;

  // step value
  double get stepValue => 1 / widget.workout.workoutExercises.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: stepValue * currentPageIndex + stepValue,
            color: Theme.of(context).primaryColor,
            semanticsValue:
                '$currentPageIndex/${widget.workout.workoutExercises.length}',
            semanticsLabel: 'Workout Progress',
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (_) => setState(() => currentPageIndex = _),
              children: widget.workout.workoutExercises
                  .map(
                    (e) => UserWorkoutInProgressExercisePage(
                      workoutExercise: e,
                    ),
                  )
                  .toList(),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentPageIndex > 0)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text('Previous'),
                        ),
                      ),
                    ),
                  if (currentPageIndex <
                      widget.workout.workoutExercises.length - 1)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text('Next'),
                        ),
                      ),
                    ),
                  if (currentPageIndex ==
                      widget.workout.workoutExercises.length - 1)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigation.pushPopup(
                              widget: UserWorkoutInProgressFinishedPopup(
                                workout: widget.workout,
                              ),
                            );
                          },
                          child: const Text('Finish'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
