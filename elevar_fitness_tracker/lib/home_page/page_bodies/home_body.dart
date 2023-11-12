/*
  This file returns the encapsulating body widget for the Home page
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';
import 'package:pedometer/pedometer.dart';
import 'package:path/path.dart';
import 'package:elevar_fitness_tracker/notifications/notifications.dart';
import 'package:elevar_fitness_tracker/notifications/notifPage.dart';

class homeBody extends StatefulWidget {
  homeBody({super.key});
  @override
  State<homeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<homeBody> {
  AppStyles styles = AppStyles();

//get out-of app notifications

  final notifications = Notifications();
  String notifTitle = "Elevar";
  String notifBody =
      "Welcome to Elevar! You have agreed to receive notifications for your workouts.";
  String? payload;

//Pedometer
  late Stream<StepCount> _stepCountStream;
  String _stepCount = "0";

  IconData currentNotifIcon = CupertinoIcons.bell;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool hasClicked = false;

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
    if ((currentNotifIcon == CupertinoIcons.bell_slash) && (!hasClicked)) {
      showNotifAlert();
      hasClicked = true;
    }
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

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Home", style: styles.getHeadingStyle()),
        backgroundColor: styles.getHighlightColor(),
        actions: [
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
          )
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150.0,
            height: 150.0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00CCFF),
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
          const SizedBox(height: 20.0), // Add some space between containers

          Container(
            width: 300.0,
            height: 150.0,
            margin: styles.getDefaultInsets(),
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
}
