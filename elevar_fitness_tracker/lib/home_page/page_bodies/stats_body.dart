import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';

class statsBody extends StatelessWidget {
  AppStyles styles = AppStyles();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Statistics",
            style: styles.getHeadingStyle(styles.getObjectColor())),
        backgroundColor: styles.getBackgroundColor(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '4 hrs this week',
                style: styles.getSubHeadingStyle(styles.getObjectColor()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  // Placeholder for the bar chart widget
                  ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                  // Placeholder for the toggle buttons or chips for Duration, Volume, Reps
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  'Max Daily Volume:',
                  style: styles.getMainTextStyle(),
                ),
                trailing: Text(
                  '24385 Lbs',
                  style: styles.getMainTextStyle(styles.getObjectColor()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  'Max Daily Reps:',
                  style: styles.getMainTextStyle(),
                ),
                trailing: Text(
                  '972 Reps',
                  style: styles.getMainTextStyle(styles.getObjectColor()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  'Heaviest Lift:',
                  style: styles.getMainTextStyle(),
                ),
                trailing: Text(
                  'Hack Squat - 650 Lbs',
                  style: styles.getMainTextStyle(styles.getObjectColor()),
                ),
              ),
            ),
            // more widgets as per needed etc
          ],
        ),
      ),
    );
  }
}
