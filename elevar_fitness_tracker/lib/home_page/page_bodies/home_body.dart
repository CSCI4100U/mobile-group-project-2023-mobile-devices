/*
  This file returns the encapsulating body widget for the Home page
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';
import 'package:pedometer/pedometer.dart';
import 'package:elevar_fitness_tracker/notifications/notifications.dart';
import 'package:elevar_fitness_tracker/notifications/notification_page.dart';
import 'package:elevar_fitness_tracker/local_storage/routine_db_model.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});
  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {

  // defining instance variables
  AppStyles styles = AppStyles();
  RoutineDBModel database = RoutineDBModel();
  List<dynamic> routineNames = [];
  late List<Map<String,dynamic>> routineData = [];
  bool refresh = true;
  bool darkmode = false;

  // Notification variables
  final notifications = Notifications();
  String notifTitle = "Elevar";
  String notifBody = "Welcome to Elevar! You have agreed to receive notifications for your workouts.";
  String? payload;

  // Pedometer variables
  late Stream<StepCount> _stepCountStream;
  String _stepCount = "0";
  IconData currentNotifIcon = CupertinoIcons.bell;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool hasClicked = false;

  // Defining instance methods
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
          title: Text('You have opted to receive notifications', style: AppStyles.getSubHeadingStyle(darkmode),),
          content: Text(
              'Hold the notification bell to see your list of workout notifications',
              style: AppStyles.getMainTextStyle(darkmode),
              ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Confirm', style: AppStyles.getMainTextStyle(darkmode),),
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

  Future initRoutineData() async {
    routineNames = await database.getDistinctRoutineNames();
    routineData = await database.getAllRoutineData();
  }

  // main widget body
  @override
  Widget build(BuildContext context) {
    notifications.init();
    if(refresh) {
      initRoutineData().then((value) {
        setState(() {
          refresh = false;
        });
      });
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppStyles.primaryColor(darkmode).withOpacity(0.2),
      appBar: AppBar(
        title: Text("Home", style: AppStyles.getHeadingStyle(darkmode)),
        backgroundColor: AppStyles.primaryColor(darkmode),
        actions: [
          ElevatedButton(
            onPressed: handleNotifButton,
            onLongPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => const NotifPage()),
                  ));
            },
            child: Icon(currentNotifIcon),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top:25.0, bottom: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox( // holds the pedometer step count
              width: double.infinity,
              height: 150.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100.0),
                      border: Border.all(width: 2.0)
                    ),
                  ),
                  Text(
                    "$_stepCount\nsteps",
                    style: AppStyles.getSubHeadingStyle(darkmode),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 50.0,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        refresh = true;
                      });
                    },
                    icon: Icon(Icons.refresh, color: AppStyles.textColor(darkmode), size: 24,)
                  )
                ],
              )
            ),

            Expanded( // holds this scrollable listview of routines
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return routineTile(routineNames[index], routineData.where((element) => element['routineName'] == routineNames[index]).toList());
                },
                separatorBuilder: (context, index) => const Divider(color: Colors.transparent),
                itemCount: routineNames.length,
              ),
            )
          ],
        ),
      )
    );
  }

  // method for generating a ListTile for the main widgets ListView
  Widget routineTile(String name, List<Map<String,dynamic>> exercises) {
    return ListTile(
      title: Text(
        name, 
        style: AppStyles.getSubHeadingStyle(darkmode),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: () {
          print("Placeholder for now");
        },
        icon: Icon(Icons.more_horiz, color: AppStyles.textColor(darkmode),),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide.none
      ),
      tileColor: AppStyles.backgroundColor(darkmode),
    );
  }
}