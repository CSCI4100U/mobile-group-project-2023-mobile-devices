import 'package:flutter/material.dart';
import 'Exercise_selection_page/add_exercise.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';
import 'package:elevar_fitness_tracker/home_page/page_bodies/workout_page/Exercise_selection_page/exercise_data.dart';

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
      appBar: AppBar(
        title: Text('Workout', style: styles.getHeadingStyle(Colors.white),),
        backgroundColor: styles.getObjectColor(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: selectedExercises.isNotEmpty ? _saveWorkout : null,
            icon: const Icon(Icons.save, color: Colors.white,)
          )
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(styles.getHighlightColor()),
                  elevation: MaterialStateProperty.all<double>(4.0),
                  side: MaterialStateProperty.all<BorderSide>(const BorderSide(color:Colors.black, width: 2.0))
                ),
                onPressed: () async {
                  List<ExerciseItem> newExercises = await Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const AddExercise())
                  );

                  if (newExercises.isNotEmpty) {
                    setState(() {
                      selectedExercises.addAll(newExercises);
                    });
                  }
                }, 
                child: Text(
                  'Add New Exercise',
                  style: styles.getSubHeadingStyle(Colors.black),
                )
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedExercises.length,
              itemBuilder:(context, index) {
                return getWorkoutItem(selectedExercises[index], index);
              },
            ),
          ),
        ],
      ), 
    );
  }

  Widget getWorkoutItem(ExerciseItem exercise, int index, ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.fitness_center, color: styles.getHighlightColor(),),
            title: Text(
              exercise.name,
              style: styles.getSubHeadingStyle(),
            ),
            subtitle: Text(exercise.muscle, style: styles.getMainTextStyle(),),
            isThreeLine: true,
            onTap: () => _showInputExerciseDialog(exercise),
          ),
          ListTile(
            title: Text(
              'Set:',
              style: styles.getSubHeadingStyle(),
            ),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    'Reps: ${exercise.reps ?? 'n/a'}',
                    style: styles.getMainTextStyle(),
                  ),
                ),
                Text(
                    'Weight: ${exercise.weight ?? 'n/a'} lbs',
                    style: styles.getMainTextStyle(),
                ),
                
              ],
            ),
            onTap: () => _showInputExerciseDialog(exercise),
          ),
          // TODO: add button for adding a set
        ],
      ),
    );
  }

  void _showInputExerciseDialog(ExerciseItem exercise) async {
    TextEditingController repsController = TextEditingController();
    TextEditingController weightController = TextEditingController();

    await showDialog(
      context: context, 
      builder:(context) {
        return AlertDialog(
          title: Text('Edit sets', style: styles.getSubHeadingStyle(),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: repsController,
                decoration: const InputDecoration(hintText: "Reps"),
                keyboardType: TextInputType.number,
                style: styles.getMainTextStyle(),
              ),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(hintText: "Weight (lbs)"),
                keyboardType: TextInputType.number,
                style: styles.getMainTextStyle(),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Save', style: styles.getSubHeadingStyle(),),
              onPressed: () {
                setState(() {
                  exercise.reps = int.tryParse(repsController.text);
                  exercise.weight = int.tryParse(weightController.text);
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveWorkout() async {
    // logic to save workout
    print('Workout saved');
  }
}

