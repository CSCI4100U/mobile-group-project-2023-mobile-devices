/*
  This file returns the encapsulating body widget for the Home page
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';
<<<<<<< Updated upstream
<<<<<<< Updated upstream
import 'package:pedometer/pedometer.dart';
=======
import 'package:path/path.dart';
import 'package:pedometer/pedometer.dart';
import 'package:elevar_fitness_tracker/notifications/notifications.dart';
import 'package:elevar_fitness_tracker/notifications/notifPage.dart';
>>>>>>> Stashed changes
=======
import 'package:pedometer/pedometer.dart';
import 'package:path/path.dart';
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
<<<<<<< Updated upstream
=======
=======
//get out-of app notifications
>>>>>>> Stashed changes
  final notifications = Notifications();
  String notifTitle = "Elevar";
  String notifBody =
      "Welcome to Elevar! You have agreed to receive notifications for your workouts.";
  String? payload;

<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
//Pedometer
>>>>>>> Stashed changes
  late Stream<StepCount> _stepCountStream;
  String _stepCount = "0";

  IconData currentNotifIcon = CupertinoIcons.bell;
<<<<<<< Updated upstream
=======
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool hasClicked = false;
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
  @override
  Widget build(BuildContext context) {
=======
=======
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
  void handleNotifButton() {
=======
  void showNotifAlert() {
    showDialog(
      context: scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You have opted to receive notifications'),
          content: Text(
              'Hold the notification bell to see your list of workout notifications'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void handleNotifButton() {
    if (!hasClicked) {
      showNotifAlert();

      hasClicked = true;
    }
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
>>>>>>> Stashed changes
    return Scaffold(
=======
    return Scaffold(
      key: scaffoldKey,
>>>>>>> Stashed changes
      appBar: AppBar(
        title: Text("Home", style: styles.getHeadingStyle()),
        backgroundColor: styles.getHighlightColor(),
        actions: [
<<<<<<< Updated upstream
          //in-app/local notifs?
<<<<<<< Updated upstream
          IconButton(
            icon: Icon(CupertinoIcons.bell),
            onPressed: (() {
              notificationIconChange();
            }),
=======
=======
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
          )
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
<<<<<<< Updated upstream
<<<<<<< Updated upstream
          // First Container with Stack
          Container(
=======
          SizedBox(
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                    color: Color(0xFF00CCFF),
=======
                    color: const Color(0xFF00CCFF),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
          SizedBox(height: 20.0), // Add some space between containers
=======
          const SizedBox(height: 20.0), // Add some space between containers
>>>>>>> Stashed changes
=======
          const SizedBox(height: 20.0), // Add some space between containers
>>>>>>> Stashed changes

          Container(
            width: 300.0,
            height: 150.0,
<<<<<<< Updated upstream
<<<<<<< Updated upstream
            margin: EdgeInsets.all(20.0),
=======
            margin: styles.getDefaultInsets(),
>>>>>>> Stashed changes
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
=======
>>>>>>> Stashed changes
}
