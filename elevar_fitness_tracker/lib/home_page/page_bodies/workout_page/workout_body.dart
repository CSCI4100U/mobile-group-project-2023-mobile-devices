import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Local prefs
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sharedPrefs) {
      setState(() {
        prefs = sharedPrefs;
        darkmode = prefs?.getBool('darkmode') ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor(darkmode),
      appBar: AppBar(
        title: Text('Workout', style: AppStyles.getHeadingStyle(darkmode),),
        backgroundColor: AppStyles.primaryColor(darkmode),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppStyles.textColor(darkmode)),
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
              child: Container(
                decoration: BoxDecoration(
                  color: AppStyles.primaryColor(darkmode),
                  borderRadius: BorderRadius.circular(100.0),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 3),
                      color: Colors.black.withOpacity(0.05)
                    ),
                    BoxShadow(
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                      color: Colors.black.withOpacity(0.1)
                    )
                  ]
                ),
                child: TextButton(
                  onPressed: () async {
                    List<ExerciseItem> newExercises = await Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const AddExercise())
                    ) ?? [];
                
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

  Widget getWorkoutItem(Map<String,dynamic> exercise, int index,) {
    return Card(
      color: darkmode ? AppStyles.primaryColor(darkmode).withOpacity(0.2) : AppStyles.backgroundColor(darkmode),
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
                    style: TextStyle(
                      fontFamily: 'Geologica',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppStyles.accentColor(darkmode)
                    ),
                  ),
                ),
                Text(
                    'Weight: ${exercise['weight'] ?? 'n/a'} lbs',
                    style: TextStyle(
                      fontFamily: 'Geologica',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppStyles.accentColor(darkmode)
                    ),
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
          title: Text("Name Your Routine?", style: AppStyles.getSubHeadingStyle(false),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: routineNameController,
                style: AppStyles.getMainTextStyle(false),
                decoration: InputDecoration(hintText: selectedExercises[0]['routineName']),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel", style: AppStyles.getSubHeadingStyle(false),),
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
              child: Text("Save", style: AppStyles.getSubHeadingStyle(false),)
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
    // logic to save workout
    selectedExercises.forEach((routineExercise) async {
      await database.insertExercise(routineExercise);
    });

    Navigator.pop(context);
  }
}

