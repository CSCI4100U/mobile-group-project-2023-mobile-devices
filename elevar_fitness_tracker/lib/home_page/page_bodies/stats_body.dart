import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';
import 'package:elevar_fitness_tracker/local_storage/exercises_db_model.dart';

class statsBody extends StatelessWidget {
  final ExerciseDBModel dbModel = ExerciseDBModel();
  bool darkmode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor(darkmode).withOpacity(0.2),
      appBar: AppBar(
        title: Text("Your Statistics",
            style: AppStyles.getHeadingStyle(darkmode)),
        backgroundColor: AppStyles.primaryColor(darkmode),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // get the max stats for each exercise
        future: dbModel.getMaxStatsForAllExercises(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Map<String, dynamic>> maxStats = snapshot.data!;
            return ListView.builder(
              itemCount: maxStats.length,
              itemBuilder: (context, index) {
                var exercise = maxStats[index];
                return ListTile(
                  title:
                      Text(exercise['name'], style: AppStyles.getSubHeadingStyle(darkmode)),
                  subtitle: Text(
                    'Max Reps: ${exercise['maxReps']} | Max Weight: ${exercise['maxWeight']} lbs',
                    style: AppStyles.getMainTextStyle(darkmode),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No exercise data available'));
          }
        },
      ),
    );
  }
}
