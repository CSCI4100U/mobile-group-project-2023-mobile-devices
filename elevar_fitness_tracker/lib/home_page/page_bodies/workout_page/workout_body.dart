import 'package:flutter/material.dart';
import 'add_exercise.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';
import 'package:elevar_fitness_tracker/home_page/page_bodies/workout_page/exercise_item.dart';


class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  WorkoutPageState createState() => WorkoutPageState();
}

class WorkoutPageState extends State<WorkoutPage> {
  AppStyles styles = AppStyles();
  List<ExerciseItem> selectedExercises = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(styles.getObjectColor()),
              elevation: MaterialStateProperty.all<double>(4.0),
              side: MaterialStateProperty.all<BorderSide>(const BorderSide(color:Colors.black,))
            ),
            onPressed: () async {
              selectedExercises = await Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const AddExercise()));
                
              selectedExercises.forEach((element) {print(element.name);});
            }, 
            child: Text(
              'Add An Exercise',
              style: styles.getSubHeadingStyle(Colors.white),
            )
          ),
        )
      )
    );
  }
}
