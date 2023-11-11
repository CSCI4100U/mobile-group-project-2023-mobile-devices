import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';
import 'package:elevar_fitness_tracker/local_storage/exercises_db_model.dart';

class statsBody extends StatelessWidget {
  final AppStyles styles = AppStyles();
  final ExerciseDBModel dbModel = ExerciseDBModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Statistics",
            style: styles.getSubHeadingStyle(styles.getObjectColor())),
        backgroundColor: styles.getBackgroundColor(),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbModel.getAllExercises(), // get all exercises
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Map<String, dynamic>> exercises = snapshot.data!;
            return ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                var exercise = exercises[index];
                return ListTile(
                  title:
                      Text(exercise['name'], style: styles.getMainTextStyle()),
                  subtitle: Text(
                      'Reps: ${exercise['heavySetReps']} | Weight: ${exercise['weight']} lbs',
                      style: styles.getMainTextStyle()),
                );
              },
            );
          } else {
            return Center(child: Text('No exercises found'));
          }
        },
      ),
    );
  }
}
