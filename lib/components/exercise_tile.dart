// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  void Function(bool?)? onChanged;

  ExerciseTile(
      {super.key,
      required this.exerciseName,
      required this.weight,
      required this.reps,
      required this.sets,
      required this.isCompleted,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(12),
      child: ListTile(
        title: Text(exerciseName),
        titleAlignment: ListTileTitleAlignment.center,
        subtitle: Row(
          children: [
            Chip(
                label: Text("$weight kg"),
                backgroundColor: Colors.grey[800],
                labelStyle: const TextStyle(color: Colors.white),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                )),
            const SizedBox(width: 4),
            Chip(
                label: Text("$reps reps"),
                backgroundColor: Colors.grey[800],
                labelStyle: const TextStyle(color: Colors.white),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                )),
            const SizedBox(width: 4),
            Chip(
                label: Text("$sets sets"),
                backgroundColor: Colors.grey[800],
                labelStyle: const TextStyle(color: Colors.white),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                )),
          ],
        ),
        trailing: Checkbox(
          value: isCompleted,
          onChanged: (value) => onChanged!(value),
        ),
      ),
    );
  }
}
