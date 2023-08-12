import 'dart:io';

import 'package:confetti/confetti.dart';
import 'package:fitness_app/models/models.dart';
import 'package:fitness_app/utils/utils.dart';
import 'package:fitness_app/view/user_workout_in_progress_exercise_page.dart';
import 'package:fitness_app/view/user_workout_in_progress_finished_popup.dart';
import 'package:fitness_app/widgets/src/my_confetti_widget.dart';
import 'package:fitness_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class UserWorkoutInProgressScreen extends StatefulWidget {
  final Workout workout;
  final Map<Tupel<Exercise, WorkoutExercise>, File?> exercises;
  const UserWorkoutInProgressScreen({
    required this.workout,
    required this.exercises,
    super.key,
  });

  @override
  State<UserWorkoutInProgressScreen> createState() =>
      _UserWorkoutInProgressScreenState();
}

class _UserWorkoutInProgressScreenState
    extends State<UserWorkoutInProgressScreen> {
  PageController pageController = PageController();

  int get currentPageIndex =>
      pageController.hasClients ? pageController.page!.round() : 0;

  double get stepValue => 1 / widget.exercises.length;

  ConfettiController confettiController =
      ConfettiController(duration: const Duration(seconds: 2));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: widget.workout.name,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: MyLinearProgressIndicator(
                  progress: stepValue * currentPageIndex + stepValue,
                ),
              ),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: widget.exercises.entries
                      .map(
                        (e) => UserWorkoutInProgressExercisePage(
                          exercise: e,
                        ),
                      )
                      .toList(),
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 30),
                  previousButton(),
                  const SizedBox(width: 20),
                  nextButton(),
                  const SizedBox(width: 30),
                ],
              ),
              const SizedBox(height: 10),
              const SafeArea(
                top: false,
                child: SizedBox(),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: MyConfettiWidget(
              controller: confettiController,
            ),
          ),
        ],
      ),
    );
  }

  Widget previousButton() => IconButton(
        onPressed: () async {
          await pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          setState(() {});
        },
        icon: Icon(Icons.adaptive.arrow_back_rounded),
      );

  Widget nextButton() => Expanded(
        child: ElevatedButton(
          onPressed: () async {
            if (currentPageIndex ==
                widget.workout.workoutExercises.length - 1) {
              confettiController.play();
              Navigation.pushPopup(
                widget: UserWorkoutInProgressFinishedPopup(
                  workout: widget.workout,
                ),
              );
            } else {
              await pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
            setState(() {});
          },
          child: Text(
            (currentPageIndex == widget.workout.workoutExercises.length - 1)
                ? 'Finish'
                : 'Next',
          ),
        ),
      );
}
