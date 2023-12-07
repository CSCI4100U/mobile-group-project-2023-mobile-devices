import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';
import 'package:elevar_fitness_tracker/local_storage/routine_db_model.dart';

class statsBody extends StatelessWidget {
  final AppStyles styles = AppStyles();
  final RoutineDBModel dbModel = RoutineDBModel();
  bool darkmode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor(darkmode).withOpacity(0.2),
      appBar: AppBar(
        title:
            Text("Your Statistics", style: AppStyles.getHeadingStyle(darkmode)),
        backgroundColor: AppStyles.primaryColor(darkmode),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbModel.getUniqueWorkoutStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Map<String, dynamic>> exerciseStats = snapshot.data!;
            return ListView.builder(
              itemCount: exerciseStats.length,
              itemBuilder: (context, index) {
                var exerciseStat = exerciseStats[index];
                return ListTile(
                  title: Text(exerciseStat['exerciseName'],
                      style: AppStyles.getSubHeadingStyle(darkmode)),
                  subtitle: Text(
                    'Max Reps: ${exerciseStat['maxReps']} | Max Weight: ${exerciseStat['maxWeight']} lbs',
                    style: AppStyles.getMainTextStyle(darkmode),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No exercise stats available'));
          }
        },
      ),
    );
  }
}
