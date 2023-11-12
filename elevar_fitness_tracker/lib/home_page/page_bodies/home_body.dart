/*
  This file returns the encapsulating body widget for the Home page
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';
<<<<<<< Updated upstream
import 'package:pedometer/pedometer.dart';
=======
import 'package:path/path.dart';
import 'package:pedometer/pedometer.dart';
import 'package:elevar_fitness_tracker/notifications/notifications.dart';
import 'package:elevar_fitness_tracker/notifications/notifPage.dart';
>>>>>>> Stashed changes

class homeBody extends StatefulWidget {
  homeBody({super.key});
  @override
  State<homeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<homeBody> {
  AppStyles styles = AppStyles();

<<<<<<< Updated upstream
=======
  final notifications = Notifications();
  String notifTitle = "Elevar";
  String notifBody =
      "Welcome to Elevar! You have agreed to receive notifications for your workouts.";
  String? payload;

>>>>>>> Stashed changes
  late Stream<StepCount> _stepCountStream;
  String _stepCount = "0";

  IconData currentNotifIcon = CupertinoIcons.bell;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void _trackStepCount(StepCount event) {
    setState(() {
      _stepCount = event.steps.toString();
    });
  }

  void _trackStepError(error) {
    setState(() {
      print("_trackStepError: $error");
    });
  }

  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_trackStepCount).onError(_trackStepError);
  }

<<<<<<< Updated upstream
  @override
  Widget build(BuildContext context) {
=======
  void notificationIconChange() {
    setState(() {
      currentNotifIcon = (currentNotifIcon == CupertinoIcons.bell)
          ? CupertinoIcons.bell_slash
          : CupertinoIcons.bell;
    });
  }

  void sendNotification() {
    notifications.sendNotification(
        notifTitle, notifBody, "This is the payload");
  }

  void handleNotifButton() {
    if (currentNotifIcon == CupertinoIcons.bell_slash) {
      notificationIconChange();
      sendNotification();
    } else if (currentNotifIcon == CupertinoIcons.bell) {
      notificationIconChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    notifications.init();

>>>>>>> Stashed changes
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: styles.getHeadingStyle()),
        backgroundColor: styles.getHighlightColor(),
        actions: [
          //in-app/local notifs?
<<<<<<< Updated upstream
          IconButton(
            icon: Icon(CupertinoIcons.bell),
            onPressed: (() {
              notificationIconChange();
            }),
=======
          ElevatedButton(
            child: Icon(currentNotifIcon),
            onPressed: handleNotifButton,
            onLongPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => NotifPage()),
                  ));
            },
>>>>>>> Stashed changes
          )
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
<<<<<<< Updated upstream
          // First Container with Stack
          Container(
=======
          SizedBox(
>>>>>>> Stashed changes
            width: 150.0,
            height: 150.0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
<<<<<<< Updated upstream
                    color: Color(0xFF00CCFF),
=======
                    color: const Color(0xFF00CCFF),
>>>>>>> Stashed changes
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
                Text(
                  "$_stepCount\nsteps",
                  style: styles.getSubHeadingStyle(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
<<<<<<< Updated upstream
          SizedBox(height: 20.0), // Add some space between containers
=======
          const SizedBox(height: 20.0), // Add some space between containers
>>>>>>> Stashed changes

          Container(
            width: 300.0,
            height: 150.0,
<<<<<<< Updated upstream
            margin: EdgeInsets.all(20.0),
=======
            margin: styles.getDefaultInsets(),
>>>>>>> Stashed changes
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.black, width: 2.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Today\'s workout:',
                style: styles.getMainTextStyle(),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      )),
    );
  }
<<<<<<< Updated upstream

  void notificationIconChange() {
    setState(() {
      currentNotifIcon = (currentNotifIcon == CupertinoIcons.bell)
          ? CupertinoIcons.bell_slash
          : CupertinoIcons.bell;
    });
  }
=======
>>>>>>> Stashed changes
}
