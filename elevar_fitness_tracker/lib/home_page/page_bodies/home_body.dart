/*
  This file returns the encapsulating body widget for the Home page
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';
import 'package:pedometer/pedometer.dart';

class homeBody extends StatefulWidget {
  homeBody({super.key});
  @override
  State<homeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<homeBody> {
  AppStyles styles = AppStyles();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: styles.getHeadingStyle()),
        backgroundColor: styles.getHighlightColor(),
        actions: [
          //in-app/local notifs?
          IconButton(
            icon: Icon(CupertinoIcons.bell),
            onPressed: (() {
              notificationIconChange();
            }),
          )
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // First Container with Stack
          Container(
            width: 150.0,
            height: 150.0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Color(0xFF00CCFF),
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
          SizedBox(height: 20.0), // Add some space between containers

          Container(
            width: 300.0,
            height: 150.0,
            margin: EdgeInsets.all(20.0),
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

  void notificationIconChange() {
    setState(() {
      currentNotifIcon = (currentNotifIcon == CupertinoIcons.bell)
          ? CupertinoIcons.bell_slash
          : CupertinoIcons.bell;
    });
  }
}
