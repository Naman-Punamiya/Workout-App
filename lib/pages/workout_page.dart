import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/components/exercise_tile.dart';
import 'package:workout_app/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  final exerciseNameTextController = TextEditingController();
  final exerciseWeightTextController = TextEditingController();
  final exerciseRepsTextController = TextEditingController();
  final exerciseSetsTextController = TextEditingController();

  void createNewExercise() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.black87,
              title: const Text("Add a new Exercise"),
              titleTextStyle: const TextStyle(color: Colors.white,fontSize: 24,),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    style: const TextStyle(color: Colors.white,),
                    controller: exerciseNameTextController,
                    decoration: const InputDecoration(
                      hintText: "Exercise Name",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: exerciseWeightTextController,
                    decoration: const InputDecoration(
                      hintText: "Weight(Kg)",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: exerciseRepsTextController,
                    decoration: const InputDecoration(
                      hintText: "Reps",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: exerciseSetsTextController,
                    decoration: const InputDecoration(
                      hintText: "Sets",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: cancel,
                  child: const Text("Cancel",style: TextStyle(color: Colors.white),),
                ),
                MaterialButton(
                  onPressed: save,
                  child: const Text("Save",style: TextStyle(color: Colors.white),),
                ),
              ],
            ));
  }

  void save() {
    String newExerciseName = exerciseNameTextController.text;
    String newExerciseWeight = exerciseWeightTextController.text;
    String newExerciseRep = exerciseRepsTextController.text;
    String newExerciseSet = exerciseSetsTextController.text;
    Provider.of<WorkoutData>(context, listen: false).addExercise(
        widget.workoutName,
        newExerciseName,
        newExerciseWeight,
        newExerciseRep,
        newExerciseSet);
    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    exerciseNameTextController.clear();
    exerciseWeightTextController.clear();
    exerciseRepsTextController.clear();
    exerciseSetsTextController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.grey[200],
              appBar: AppBar(
                title: Text(widget.workoutName),
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                centerTitle: true,
              ),
              floatingActionButton: FloatingActionButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  onPressed: () => createNewExercise(),
                  child: const Icon(Icons.add_rounded)),
              body: ListView.builder(
                  itemCount:
                      value.numberOfExerciseInWorkout(widget.workoutName),
                  itemBuilder: (context, index) => ExerciseTile(
                        exerciseName: value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .name,
                        weight: value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .weight,
                        reps: value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .reps,
                        sets: value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .sets,
                        isCompleted: value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .isCompleted,
                        onChanged: (val) => onCheckBoxChanged(
                            widget.workoutName,
                            value
                                .getRelevantWorkout(widget.workoutName)
                                .exercises[index]
                                .name),
                      )),
            ));
  }
}
