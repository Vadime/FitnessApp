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
  List<ExerciseUI> filteredExercisesOth = [];

  TextFieldController searchController =
      TextFieldController('Suche nach Übungen');

  @override
  void initState() {
    super.initState();
    nameBloc = TextFieldController.name(
      text: widget.workout?.name,
    );
    descriptionBloc = TextFieldController(
      'Beschreibung',
      text: widget.workout?.description,
    );
    scheduleController = SingleSelectionController(
      widget.workout?.schedule != null
          ? widget.workout!.schedule
          : Schedule.daily,
    );
    searchController.addListener(() {
      //filter exercises
      filterExercises(searchController);
      setState(() {});
    });

    UserRepository.currentUserCustomExercisesAsFuture.then((value) async {
      for (var element in value) {
        var image = await ExerciseRepository.getExerciseImages(element);
        exercisesOth.add(ExerciseUI(element, image));
        filteredExercisesOth.add(ExerciseUI(element, image));
      }
      setState(() {});
    });

    ExerciseRepository.getExercises().then(
      (exercises) async {
        var selectedExercises = (widget.workout?.workoutExercises
              ?..sort((a, b) => a.index.compareTo(b.index))) ??
            [];

        // Get exercises for workout
        for (int i = 0; i < exercises.length; i++) {
          Exercise exercise = exercises[i];
          var image = await ExerciseRepository.getExerciseImages(exercise);
          var workoutExercise = selectedExercises.firstWhere(
            (e) => e.exerciseUID == exercise.uid,
            orElse: () => WorkoutExercise.empty(),
          );
          if (workoutExercise.exerciseUID.isNotEmpty) {
            exercisesSel.add(
              WorkoutExerciseUI(ExerciseUI(exercise, image), workoutExercise),
            );
          } else {
            filteredExercisesOth.add(ExerciseUI(exercise, image));
            exercisesOth.add(ExerciseUI(exercise, image));
          }
          exercisesSel.sort(
            (a, b) =>
                a.workoutExercise.index.compareTo(b.workoutExercise.index),
          );
          filteredExercisesOth
              .sort((a, b) => a.exercise.name.compareTo(b.exercise.name));
          exercisesOth
              .sort((a, b) => a.exercise.name.compareTo(b.exercise.name));

          if (context.mounted) setState(() {});
        }
      },
    );
  }

  void filterExercises(searchController) {
    // Get the search query from the searchController
    String searchQuery = searchController.text.toLowerCase();

    // Filter favorite exercises
    filteredExercisesOth = exercisesOth.where((exercise) {
      return exercise.exercise.name.toLowerCase().contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: 'Trainingsplan erstellen',
      actions: [
        if (widget.workout != null) deleteButton(),
      ],
      primaryButton: addUpdateButton(),
      body: ScrollViewWidget(
        maxInnerWidth: 600,
        children: [
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
          TextWidget(
            'Zeitplan',
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

          TextWidget(
            'Übungen',
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          if (exercisesSel.isEmpty)
            SizedBox(
              height: 100,
              child: Center(
                child: TextWidget(
                  'Keine Übungen ausgewählt',
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
              key: Key(
                exercisesSel.elementAt(index).exerciseUI.exercise.uid,
              ),
              entry: exercisesSel.elementAt(index),
              exercisesSel: exercisesSel,
              exercisesOth: filteredExercisesOth,
              parentState: setState,
            ),
          ),
          const SizedBox(height: 10),
          TextWidget(
            'Weitere Übungen',
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          // search bar
          TextFieldWidget(
            controller: searchController,
          ),
          const SizedBox(height: 10),
          if (filteredExercisesOth.isEmpty)
            SizedBox(
              height: 100,
              child: Center(
                child: TextWidget(
                  'Keine weiteren Übungen vorhanden',
                  style: context.textTheme.labelSmall,
                ),
              ),
            ),
          for (var e in filteredExercisesOth)
            WorkoutExerciseNotSelectedWidget(
              entry: e,
              exercisesSel: exercisesSel,
              exercisesOth: filteredExercisesOth,
              setState: setState,
            ),
        ],
      ),
    );
  }

  Widget addUpdateButton() {
    return Expanded(
      child: ElevatedButtonWidget(
        'Trainingsplan speichern',
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
            Navigation.flush(widget: const HomeScreen(initialIndex: 0));
          } catch (e) {
            ToastController().show(e);
          }
        },
      ),
    );
  }

  Widget deleteButton() => IconButtonWidget(
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
      );
}
