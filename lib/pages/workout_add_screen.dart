import 'package:fitnessapp/database/database.dart';
import 'package:fitnessapp/models/models.dart';
import 'package:fitnessapp/pages/home/home_screen.dart';
import 'package:fitnessapp/pages/workout_delete_popup.dart';
import 'package:fitnessapp/utils/exercise_ui.dart';
import 'package:fitnessapp/utils/workout_exercise_ui.dart';
import 'package:fitnessapp/widgets/workout_exercise_not_selected_widget.dart';
import 'package:fitnessapp/widgets/workout_exercise_selected_widget.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class WorkoutAddScreen extends StatefulWidget {
  final Workout? workout;
  final Future Function(Workout newWorkout) upload;
  final Future Function()? delete;
  const WorkoutAddScreen({
    this.workout,
    required this.upload,
    required this.delete,
    super.key,
  });

  @override
  State<WorkoutAddScreen> createState() => _WorkoutAddScreenState();
}

class _WorkoutAddScreenState extends State<WorkoutAddScreen> {
  late TextFieldController nameBloc;
  late TextFieldController descriptionBloc;
  late SingleSelectionController<Schedule> scheduleController;

  List<WorkoutExerciseUI> exercisesSel = [];
  List<ExerciseUI> exercisesOth = [];

  @override
  void initState() {
    super.initState();
    nameBloc = TextFieldController.name(
      text: widget.workout?.name,
    );
    descriptionBloc = TextFieldController(
      'Description',
      text: widget.workout?.description,
    );
    scheduleController = SingleSelectionController(
      widget.workout?.schedule != null
          ? widget.workout!.schedule
          : Schedule.daily,
    );
    ExerciseRepository.getExercises().then(
      (exercises) async {
        var selectedExercises = (widget.workout?.workoutExercises
              ?..sort((a, b) => a.index.compareTo(b.index))) ??
            [];

        // Get exercises for workout
        for (int i = 0; i < exercises.length; i++) {
          Exercise exercise = exercises[i];
          var image = await ExerciseRepository.getExerciseImage(exercise);
          var workoutExercise = selectedExercises.firstWhere(
            (e) => e.exerciseUID == exercise.uid,
            orElse: () => WorkoutExercise.empty(),
          );
          if (workoutExercise.exerciseUID.isNotEmpty) {
            exercisesSel.add(
              WorkoutExerciseUI(ExerciseUI(exercise, image), workoutExercise),
            );
          } else {
            exercisesOth.add(ExerciseUI(exercise, image));
          }
          exercisesSel.sort(
            (a, b) =>
                a.workoutExercise.index.compareTo(b.workoutExercise.index),
          );
          exercisesOth
              .sort((a, b) => a.exercise.name.compareTo(b.exercise.name));

          if (context.mounted) setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const AppBarWidget(
        'Add Workout',
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Row(
          children: [
            const SizedBox(width: 30),
            if (widget.workout != null) deleteButton(),
            addUpdateButton(),
            const SizedBox(width: 30),
          ],
        ),
      ),
      body: ListView(
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        children: [
          const SafeArea(
            bottom: false,
            child: SizedBox(),
          ),
          // name and description
          CardWidget(
            children: [
              TextFieldWidget(
                controller: nameBloc,
              ),
              TextFieldWidget(
                controller: descriptionBloc,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Schedule',
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          SingleSelectionButton(
            buttons: [
              for (var type in Schedule.values)
                ButtonData(
                  type.str,
                  type,
                ),
            ],
            controller: scheduleController,
          ),
          const SizedBox(height: 20),
          Text(
            'Exercises',
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          if (exercisesSel.isEmpty)
            SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  'No exercises in this workout yet',
                  style: context.textTheme.labelSmall,
                ),
              ),
            ),
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: exercisesSel.length,
            onReorder: (oldIndex, newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              exercisesSel.elementAt(oldIndex).workoutExercise.index = newIndex;
              exercisesSel.elementAt(newIndex).workoutExercise.index = oldIndex;
              exercisesSel.sort(
                (a, b) =>
                    a.workoutExercise.index.compareTo(b.workoutExercise.index),
              );
              setState(() {});
            },
            itemBuilder: (context, index) => WorkoutExerciseSelectedWidget(
              key: Key(exercisesSel.elementAt(index).exerciseUI.exercise.uid),
              entry: exercisesSel.elementAt(index),
              exercisesSel: exercisesSel,
              exercisesOth: exercisesOth,
              parentState: setState,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Other exercises',
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          if (exercisesOth.isEmpty)
            SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  'No exercises left to add',
                  style: context.textTheme.labelSmall,
                ),
              ),
            ),
          for (var e in exercisesOth)
            WorkoutExerciseNotSelectedWidget(
              entry: e,
              exercisesSel: exercisesSel,
              exercisesOth: exercisesOth,
              setState: setState,
            ),
          const SafeArea(
            top: false,
            child: SizedBox(height: 0),
          ),
        ],
      ),
    );
  }

  Widget addUpdateButton() {
    return Expanded(
      child: ElevatedButtonWidget(
        'Save Workout',
        onPressed: () async {
          if (!nameBloc.isValid()) return;
          if (!descriptionBloc.isValid()) return;
          try {
            exercisesSel.sort(
              (a, b) =>
                  a.workoutExercise.index.compareTo(b.workoutExercise.index),
            );

            Workout workout = Workout(
              uid: widget.workout?.uid ??
                  WorkoutRepository.collectionReference.doc().id,
              name: nameBloc.text,
              description: descriptionBloc.text,
              schedule: scheduleController.state ?? Schedule.daily,
              workoutExercises:
                  exercisesSel.map((e) => e.workoutExercise).toList(),
            );
            await widget.upload(workout);
            Navigation.flush(widget: const HomeScreen(initialIndex: 1));
          } catch (e) {
            ToastController().show(e);
          }
        },
      ),
    );
  }

  Widget deleteButton() => Padding(
        padding: const EdgeInsets.only(right: 20),
        child: IconButtonWidget(
          Icons.delete_rounded,
          onPressed: () {
            // Needs to return void not future because of Loadingscreen
            Navigation.pushPopup(
              widget: WorkoutDeletePopup(
                workout: widget.workout!,
                delete: widget.delete!,
              ),
            );
            return;
          },
        ),
      );
}
