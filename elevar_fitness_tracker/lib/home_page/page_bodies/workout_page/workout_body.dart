import 'package:flutter/material.dart';
import 'Exercise_selection_page/add_exercise.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';
import 'package:elevar_fitness_tracker/home_page/page_bodies/workout_page/Exercise_selection_page/exercise_data.dart';
import 'package:elevar_fitness_tracker/local_storage/routine_db_model.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  WorkoutPageState createState() => WorkoutPageState();
}

class WorkoutPageState extends State<WorkoutPage> {
  List<Map<String,dynamic>> selectedExercises = [];
  RoutineDBModel database = RoutineDBModel();
  bool darkmode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout', style: AppStyles.getHeadingStyle(darkmode),),
        backgroundColor: AppStyles.primaryColor(darkmode),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed:() {
              selectedExercises.isNotEmpty ? _showSaveWorkoutDialog()
              : _throwSnackBarErrorMessage("Cannot save empty workout!");
            },
            icon: Icon(Icons.save, color: AppStyles.textColor(darkmode),)
          )
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(AppStyles.primaryColor(darkmode)),
                  elevation: MaterialStateProperty.all<double>(4.0),
                  side: MaterialStateProperty.all<BorderSide>(const BorderSide(color:Colors.black, width: 2.0))
                ),
                onPressed: () async {
                  List<ExerciseItem> newExercises = await Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const AddExercise())
                  );

                  int numRoutines = await database.getNumDistinctRoutines();

                  if (newExercises.isNotEmpty) {
                    setState(() {
                      // Get number of unique routine names to set default name
                      selectedExercises.addAll(newExercises.map((e) {
                        return {'routineName':'Routine_${numRoutines+1}', 'exerciseName':e.name, 'muscle':e.muscle, 'heavySetReps':e.reps, 'weight':e.weight};
                      },).toList());
                    });
                  }
                }, 
                child: Text(
                  'Add New Exercise',
                  style: AppStyles.getSubHeadingStyle(darkmode),
                )
              ),
            ),
          ),
         Expanded(
            child: ReorderableListView.builder(
              onReorder: _onReorder,
              itemBuilder: (context, index) {
                final exercise = selectedExercises[index];
                return getWorkoutItem(exercise, index, ValueKey('$index'));
              },
              itemCount: selectedExercises.length,
            ),
          ),
        ],
      ), 
    );
  }
    void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1; // if moving down the list
    }
    setState(() {
      final item = selectedExercises.removeAt(oldIndex);
      selectedExercises.insert(newIndex, item);
    });
  }
  Widget getWorkoutItem(Map<String,dynamic> exercise, int index, Key key,) {
    return ReorderableDelayedDragStartListener(
      key: key,
      index: index,
      child: Card (
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
            trailing: IconButton(
              onPressed: () {
                selectedExercises.removeWhere((element) => element['exerciseName'] == exercise['exerciseName']);
                setState(() {
                  
                });
              },
              icon: Icon(Icons.delete, size: 24, color: AppStyles.textColor(darkmode),),
            ),
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
                decoration: const InputDecoration(hintText: "Reps"),
                keyboardType: TextInputType.number,
                style: AppStyles.getMainTextStyle(darkmode),
              ),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(hintText: "Weight (lbs)"),
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
              onPressed: () {
                setState(() {
                  exercise['heavySetReps'] = int.tryParse(repsController.text);
                  exercise['weight'] = int.tryParse(weightController.text);
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  // dialog for naming a created workout/routine
  void _showSaveWorkoutDialog() async {
    TextEditingController routineNameController = TextEditingController();

    await showDialog(
      context: context,
      builder:(context) {
        return AlertDialog(
          title: Text("Name Your Routine?", style: AppStyles.getSubHeadingStyle(darkmode),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: routineNameController,
                style: AppStyles.getMainTextStyle(darkmode),
                decoration: InputDecoration(hintText: selectedExercises[0]['routineName']),
              )
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
              onPressed: () {
                String routineName = routineNameController.text;
                if(routineName.isNotEmpty) {
                  setState(() {
                    selectedExercises = selectedExercises.map((element) {
                      element['routineName'] = routineName;
                      return element;
                    }).toList();
                  });
                }
                Navigator.of(context).pop();
                _saveWorkout();
              },
              child: Text("Save", style: AppStyles.getSubHeadingStyle(darkmode),)
            ),
          ],
        );
      },
    );
  }

  void _throwSnackBarErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message, 
          textAlign: TextAlign.center,
          style: AppStyles.getMainTextStyle(darkmode, Colors.white),
        )
      )
    );
  }

  Future<void> _saveWorkout() async {
    selectedExercises.forEach((routineExercise) async {
      await database.insertExercise(routineExercise);
    });

    Navigator.pop(context);
  }
}

