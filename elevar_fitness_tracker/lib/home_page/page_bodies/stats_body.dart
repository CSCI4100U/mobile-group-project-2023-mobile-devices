import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';
import 'package:elevar_fitness_tracker/local_storage/exercises_db_model.dart';

class statsBody extends StatefulWidget {
  @override
  _statsBodyState createState() => _statsBodyState();
}

class _statsBodyState extends State<statsBody> {
  final ExerciseDBModel dbModel = ExerciseDBModel();

  @override
  Widget build(BuildContext context) {
    AppStyles styles = AppStyles();

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Statistics",
            style: styles.getSubHeadingStyle(Colors.white)),
        backgroundColor: styles.getBackgroundColor(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              // Use a FutureBuilder to wait for the stats to be fetched from the database
              child: FutureBuilder<Map<String, dynamic>>(
                future: dbModel.getExercise(
                    'Barbell Bicep Curl'), // Replace with your actual method call
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // If the Future is still running, show a loading indicator
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // If we run into an error, display it to the user
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    // If the snapshot has data, we display it accordingly
                    final exerciseData = snapshot.data!;
                    final duration = exerciseData['duration'] as int?;
                    // Ensure we check for null before using the duration
                    if (duration != null) {
                      return Text(
                        '$duration hrs this week',
                        style:
                            styles.getSubHeadingStyle(styles.getObjectColor()),
                      );
                    } else {
                      // Handle the case where duration is null
                      return Text(
                        'No duration data available',
                        style:
                            styles.getSubHeadingStyle(styles.getObjectColor()),
                      );
                    }
                  } else {
                    // If the snapshot has no data, display a message to the user
                    return Text('No exercise data found');
                  }
                },
              ),
            ),
            // ... more stats if needed
          ],
        ),
      ),
    );
  }
}
