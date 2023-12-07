import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';
import 'package:elevar_fitness_tracker/local_storage/routine_db_model.dart';

class RoutineView extends StatefulWidget {
  RoutineView(this.routineTitle);

  final String routineTitle;
  
  @override
  RoutineViewState createState() => RoutineViewState();
}

class RoutineViewState extends State<RoutineView> {
  bool darkmode = false;
  List<Map<String,dynamic>> exercises = [];
  RoutineDBModel database = RoutineDBModel();
  bool refresh = true;

  Future init() async {
    exercises = await database.getRoutine(widget.routineTitle);
  }

  @override
  Widget build(BuildContext context) {
    if (refresh) {
      init().then((value) {
        setState(() {
          refresh = false;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routineTitle, style: AppStyles.getHeadingStyle(darkmode),),
        backgroundColor: AppStyles.primaryColor(darkmode),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: exercises.length,
                itemBuilder:(context, index) {
                  return getWorkoutItem(exercises[index], index);
                },
              ),
            ),
          ]
        ),
      ),
    );
  }

  Widget getWorkoutItem(Map<String,dynamic> exercise, int index,) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.fitness_center, color: AppStyles.highlightColor(darkmode),),
            title: Text(
              exercise['exerciseName'],
              style: AppStyles.getSubHeadingStyle(darkmode),
            ),
            subtitle: Text(exercise['muscle'], style: AppStyles.getMainTextStyle(darkmode),),
            isThreeLine: true,
            onTap: () => _showInputExerciseDialog(exercise),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 40.0),
                  child: Text(
                    'Reps: ${exercise['heavySetReps'] ?? 'n/a'}',
                    style: AppStyles.getMainTextStyle(darkmode),
                  ),
                ),
                Text(
                    'Weight: ${exercise['weight'] ?? 'n/a'} lbs',
                    style: AppStyles.getMainTextStyle(darkmode),
                ),
                
              ],
            ),
            onTap: () => _showInputExerciseDialog(exercise),
          ),
        ],
      ),
    );
  }

  void _showInputExerciseDialog(Map<String,dynamic> exercise) async {
    TextEditingController repsController = TextEditingController();
    TextEditingController weightController = TextEditingController();

    await showDialog(
      context: context, 
      builder:(context) {
        return AlertDialog(
          title: Text('Edit sets', style: AppStyles.getSubHeadingStyle(darkmode),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: repsController,
                decoration: InputDecoration(
                  hintText: exercise['heavySetReps'] == null ? "Reps"
                  : exercise['heavySetReps'].toString(),
                ),
                keyboardType: TextInputType.number,
                style: AppStyles.getMainTextStyle(darkmode),
              ),
              TextField(
                controller: weightController,
                decoration:  InputDecoration(
                  hintText: exercise['weight'] == null ? "Weight (lbs)"
                  : exercise['weight'].toString(),
                ),
                keyboardType: TextInputType.number,
                style: AppStyles.getMainTextStyle(darkmode),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: AppStyles.getSubHeadingStyle(darkmode),),
            ),
            TextButton(
              child: Text('Save', style: AppStyles.getSubHeadingStyle(darkmode),),
              onPressed: () async {
                int? reps = int.tryParse(repsController.text);
                double? weight;
                if(weightController.text.isNotEmpty && weightController.text.contains('.')) {
                  print("parser 1");
                  weight = double.tryParse(weightController.text);
                } else if (weightController.text.isNotEmpty) {
                  print("parser 2");
                  weight = double.tryParse("${weightController.text}.0");
                }
                
                if(reps == null && weight == null) {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                  print("null values");
                } else if (reps != null && weight == null) {
                  int n = await database.updateExercise(exercise['exerciseName'], reps, 0.0);
                  setState(() {
                    refresh = true;
                    Navigator.of(context).pop();
                  });
                } else if (weight != null && reps == null) {
                  int n = await database.updateExercise(exercise['exerciseName'], 0, weight);
                  setState(() {
                    refresh = true;
                    Navigator.of(context).pop();
                  });
                } else {
                  int n = await database.updateExercise(exercise['exerciseName'], reps!, weight!);
                  setState(() {
                    refresh = true;
                    Navigator.of(context).pop();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}