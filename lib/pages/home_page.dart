import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/components/heat_map.dart';
import 'package:workout_app/data/workout_data.dart';
import 'package:workout_app/pages/workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  final newWorkoutNameController = TextEditingController();

  void createNewWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Create New Workout"),
              backgroundColor: Colors.black87,
              titleTextStyle: const TextStyle(color: Colors.white,fontSize: 24,),
              content: TextField(
                controller: newWorkoutNameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Workout Name",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: cancel,
                  child: const Text("Cancel",style: TextStyle(color: Colors.white),),
                ),
                MaterialButton(
                  onPressed: save,
                  child: const Text("Save",style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ));
  }

  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutPage(workoutName: workoutName)));
  }

  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);
    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Workout Tracker"),
          centerTitle: true,
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          onPressed: createNewWorkout,
          child: const Icon(Icons.add),
        ),
        body: Container(
          color: Colors.green[100],
          child: ListView(children: [
            MyHeatMap(
                datasets: value.heatMapDataSet,
                startDateYYYYMMDD: value.getStartDate()),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getWorkoutList().length,
                itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12)),
                      alignment: Alignment.center,
                      height: 80,
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        textColor: Colors.white,
                        leading: const Image(image: AssetImage("assets/barbell.png")),
                        title: Text(
                          value.getWorkoutList()[index].name.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () => goToWorkoutPage(
                              value.getWorkoutList()[index].name),
                        ),
                      ),
                    )),
          ]),
        ),
      ),
    );
  }
}
