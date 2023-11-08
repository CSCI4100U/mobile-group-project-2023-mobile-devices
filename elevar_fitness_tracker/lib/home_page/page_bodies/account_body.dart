/*
  This file returns the encapsulating body widget for the Account page
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:elevar_fitness_tracker/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget accountBody() {
  AppStyles styles = AppStyles();

  String username = "testuser1";
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  return Scaffold(
    appBar: AppBar(
      title: Text(
        "Account",
        style: styles.getHeadingStyle()
      ),
      backgroundColor: styles.getHighlightColor(),
      actions: <Widget>[
        IconButton(
          icon: const Icon(CupertinoIcons.square_arrow_left),
          onPressed: () {
            
          },
        )
      ]
    ),
    body: Container(
      padding: styles.getDefaultInsets(),
      child: Column(children: [
        Container(
          decoration: BoxDecoration(
            color: styles.getBackgroundColor(),
            borderRadius: const BorderRadius.all(Radius.circular(10))
          ),
          child: Column(children: [
            Row(children: [Padding(padding: styles.getDefaultInsets(), child: Text("$username's Info", style: styles.getSubHeadingStyle()))]),
            FutureBuilder(
              future: users.doc(username).get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Something went wrong!", style: styles.getSubHeadingStyle()));
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Center(child: Text("Could not fetch data for '$username'!", style: styles.getSubHeadingStyle()));
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

                  return ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        leading: const Tooltip(
                          message: "Name",
                          child: Icon(CupertinoIcons.person_crop_circle_fill)
                        ),
                        title: Text("${data['first_name']} ${data['last_name']}", style: styles.getSubHeadingStyle()),
                        trailing: IconButton(
                          icon: const Icon(CupertinoIcons.pencil),
                          onPressed: () {

                          },
                        )
                      ),
                      ListTile(
                        leading: const Tooltip(
                          message: "Age",
                          child: Icon(CupertinoIcons.clock_fill)
                        ),
                        title: Text("${data['age']}", style: styles.getSubHeadingStyle()),
                        trailing: IconButton(
                          icon: const Icon(CupertinoIcons.pencil),
                          onPressed: () {

                          },
                        )
                      )
                    ]
                  );
                }

                return Center(child: Text("Loading...", style: styles.getSubHeadingStyle()));
              }
            )
          ]),
        )
      ],)
    )
  );
}