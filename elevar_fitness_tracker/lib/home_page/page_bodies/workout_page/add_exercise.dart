import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';
import 'package:elevar_fitness_tracker/home_page/page_bodies/workout_page/exercise_item.dart';
import 'package:elevar_fitness_tracker/http/http_model.dart';

class AddExercise extends StatefulWidget {
  const AddExercise({super.key});

  @override
  AddExerciseState createState() => AddExerciseState();
}

class AddExerciseState extends State<AddExercise> {
  AddExerciseState() {
    selectedValue = states[0];
  }

  final formkey = GlobalKey<FormState>();
  final AppStyles styles = AppStyles();
  final HttpModel http = HttpModel();
  TextEditingController textControl = TextEditingController();
  bool refresh = true;
  List<ExerciseItem> exercises = [];
  List<ExerciseItem> selectedExercises = [];

  final List<String> states = [
    'abdominals',
    'abductors',
    'adductors',
    'biceps',
    'calves',
    'chest',
    'forearms',
    'glutes',
    'hamstrings',
    'lats',
    'lower_back',
    'middle_back',
    'neck',
    'quadriceps',
    'traps',
    'triceps'
  ];
  String? selectedValue;

  Future<void> init() async {
    // initial http request on page build
    exercises = await http.getExerciseItemByMuscle(selectedValue!);
  }

  @override
  Widget build(BuildContext context) {
    if (refresh) {
      init().then(
        (value) {
          setState(() {
            refresh = false;
          });
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises', style: styles.getHeadingStyle()),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField(
                  value: null,
                  key: formkey,
                  items: states.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: styles.getSubHeadingStyle(),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                      refresh = true;
                    });
                  },
                  icon: Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: styles.getObjectColor(),
                  ),
                  decoration: InputDecoration(
                    labelText: "Select Muscle:",
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: styles.getObjectColor())),
                  ),
                )),
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return exerciseTile(
                    exercises[index].name,
                    exercises[index].muscle,
                    exercises[index].isSelected,
                    index);
              },
              separatorBuilder: (context, index) => Divider(
                color: styles.getObjectColor(),
              ),
              itemCount: exercises.length,
            ),
          ),
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        styles.getObjectColor()),
                    elevation: MaterialStateProperty.all<double>(4.0),
                  ),
                  child: Text(
                    'Add All',
                    style: styles.getSubHeadingStyle(Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context, selectedExercises);
                    setState(() {
                      selectedExercises.forEach((element) {
                        element.isSelected = false;
                      });
                      selectedExercises = [];
                    });
                  },
                ),
              ))
        ],
      ),
    );
  }

  Widget exerciseTile(String name, String muscle, bool isSelected, int index) {
    return ListTile(
      leading: Icon(
        Icons.area_chart,
        color: styles.getHighlightColor(),
      ),
      title: Text(
        name,
        style: styles.getSubHeadingStyle(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        muscle,
        style: styles.getMainTextStyle(styles.getObjectColor()),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_box_rounded,
              color: styles.getHighlightColor(),
            )
          : Icon(
              Icons.check_box_outline_blank_rounded,
              color: styles.getObjectColor(),
            ),
      onTap: () {
        setState(() {
          exercises[index].isSelected = !exercises[index].isSelected;
          if (exercises[index].isSelected == true) {
            selectedExercises.add(exercises[index]);
          } else if (exercises[index].isSelected == false) {
            selectedExercises.removeWhere(
                (element) => element.name == exercises[index].name);
          }
        });
      },
    );
  }
}
