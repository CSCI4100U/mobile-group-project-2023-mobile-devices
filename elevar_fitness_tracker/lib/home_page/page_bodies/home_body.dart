/*
  This file returns the encapsulating body widget for the Home page
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';
import 'package:pedometer/pedometer.dart';
import 'package:elevar_fitness_tracker/notifications/notifications.dart';
import 'package:elevar_fitness_tracker/notifications/notification_page.dart';

class HomeBody extends StatefulWidget {
  HomeBody({super.key});
  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
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
          title: Text('You have opted to receive notifications', style: styles.getSubHeadingStyle(),),
          content: Text(
              'Hold the notification bell to see your list of workout notifications',
              style: styles.getMainTextStyle(),
              ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Confirm', style: styles.getMainTextStyle(),),
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
        title: Text("Home", style: styles.getHeadingStyle(Colors.white)),
        backgroundColor: styles.getObjectColor(),
        actions: [
          ElevatedButton(
            child: Icon(currentNotifIcon),
            onPressed: handleNotifButton,
            onLongPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const NotifPage()),
                  ));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top:25.0, bottom: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
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
                      border: Border.all(width: 2.0)
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
      
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: Container(
                width: 300.0,
                height: 150.0,
                margin: styles.getDefaultInsets(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.black, width: 2.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Today\'s workout:',
                    style: styles.getMainTextStyle(),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}