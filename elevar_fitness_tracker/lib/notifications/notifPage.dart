<<<<<<< Updated upstream
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
=======
>>>>>>> Stashed changes
import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({super.key});

  @override
  State<NotifPage> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  AppStyles styles = AppStyles();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications", style: styles.getHeadingStyle()),
        backgroundColor: styles.getHighlightColor(),
      ),
      body: ListView(children: [
        ListTile(
          title: Text(''),
        )
      ]),
    );
  }
}
