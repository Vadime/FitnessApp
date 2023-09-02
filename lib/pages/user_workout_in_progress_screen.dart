import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/utils/workout_exercise_ui.dart';
import 'package:fitnessapp/pages/user_workout_in_progress_exercise_page.dart';
import 'package:fitnessapp/pages/user_workout_in_progress_finished_popup.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class UserWorkoutInProgressScreen extends StatefulWidget {
  final Workout workout;
  final List<WorkoutExerciseUI> exercises;
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

  PartyController confettiController =
      PartyController(duration: const Duration(seconds: 2));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        widget.workout.name,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: LinearProgressWidget(
                  stepValue * currentPageIndex + stepValue,
                ),
              ),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: widget.exercises
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
            child: PartyWidget(
              controller: confettiController,
            ),
          ),
        ],
      ),
    );
  }

  Widget previousButton() => IconButtonWidget(
        Icons.adaptive.arrow_back_rounded,
        onPressed: () async {
          await pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          setState(() {});
        },
      );

  Widget nextButton() => Expanded(
        child: ElevatedButtonWidget(
          (currentPageIndex == widget.workout.workoutExercises.length - 1)
              ? 'Finish'
              : 'Next',
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
        ),
      );
}
