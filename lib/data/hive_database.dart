import 'package:hive/hive.dart';
import 'package:workout_app/datetime/date_time.dart';
import 'package:workout_app/models/exercise.dart';
import 'package:workout_app/models/workout.dart';

class HiveDatabase {
  final _myBox = Hive.box("workout_database");

  bool previousDataExists() {
    if (_myBox.isEmpty) {
      _myBox.put("START_DATE", todayDateYYYYMMDD());
      return false;
    } else {
      return true;
    }
  }

  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  void saveToDatabase(List<Workout> workouts) {
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_${todayDateYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todayDateYYYYMMDD()}", 0);
    }

    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    for (int i = 0; i < workoutNames.length; i++) {
      List<Exercise> exerciseInEachWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        exerciseInEachWorkout.add(Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "true" ? true : false));
      }

      Workout workout =
          Workout(name: workoutNames[i], exercises: exerciseInEachWorkout);

      mySavedWorkouts.add(workout);
    }

    return mySavedWorkouts;
  }

  bool exerciseCompleted(List<Workout> workouts) {
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  int getCompletedStatus(String yyyymmdd){
    int completionStatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }
}

List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(
      workouts[i].name,
    );
  }

  return workoutList;
}

List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];

  for (int i = 0; i < workouts.length; i++) {
    List<Exercise> exerciseInWorkout = workouts[i].exercises;
    List<List<String>> individualWorkout = [];

    for (int j = 0; j < exerciseInWorkout.length; j++) {
      List<String> individualExercise = [];
      individualExercise.addAll(
        [
          exerciseInWorkout[j].name,
          exerciseInWorkout[j].weight,
          exerciseInWorkout[j].reps,
          exerciseInWorkout[j].sets,
          exerciseInWorkout[j].isCompleted.toString(),
        ],
      );
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }
  return exerciseList;
}
