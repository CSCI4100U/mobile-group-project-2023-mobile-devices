/*
  This file returns the encapsulating body widget for the Account page
*/
import 'package:elevar_fitness_tracker/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:elevar_fitness_tracker/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String formatTimestamp(DateTime date) {
  return "${date.year.toString()}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
}

void editNameDialog(String username, Map<String, dynamic> data, TextEditingController firstNameController, TextEditingController lastNameController, Function() notifyParent) {
  AppStyles styles = AppStyles();
  
  firstNameController.text = data['first_name'];
  lastNameController.text = data['last_name'];
  
  showDialog(
    context: navigatorKey.currentState!.overlay!.context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Name', style: styles.getSubHeadingStyle()),
        content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(label: Text("First Name")),
                controller: firstNameController
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text("Last Name")),
                controller: lastNameController
              )
            ],
          )
        ),
        actions: <Widget>[
          MaterialButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);              
            }
          ),
          MaterialButton(
            color: styles.getHighlightColor(),
            child: const Text("Confirm"),
            onPressed: () {
              FirebaseFirestore.instance.collection('users').doc(username).update({
                'first_name': firstNameController.text,
                'last_name': lastNameController.text
              });

              notifyParent();

              Navigator.pop(context);         
            }
          )
        ],
      );
    }
  );
}

void editBirthdateDialog(String username, Map<String, dynamic> data, Function() notifyParent) async {
  AppStyles styles = AppStyles();

  BuildContext context = navigatorKey.currentState!.overlay!.context;
  final DateTime? picked = await showDatePicker(
    context: context,
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    initialDate: (data['birthdate'] as Timestamp).toDate(),
    firstDate: DateTime(1950),
    lastDate: DateTime.now(),
    cancelText: "Cancel",
    confirmText: "Confirm",
    helpText: "Edit Birthdate",
  );

  if (picked != null) {
    FirebaseFirestore.instance.collection('users').doc(username).update({
      'birthdate': Timestamp.fromDate(picked),
    });

    notifyParent();
  }
}

ListTile generateUserEntry(String entryName, IconData? icon, String text, Function() onPress) {
  AppStyles styles = AppStyles();
  
  return ListTile(
    leading: Tooltip(
      message: entryName,
      child: Icon(icon)
    ),
    title: Text(text, style: styles.getSubHeadingStyle()),
    trailing: IconButton(
      icon: const Icon(CupertinoIcons.pencil),
      onPressed: () {
        onPress();
    },
  ));
}

Widget accountBody(Function() notifyParent) {
  AppStyles styles = AppStyles();

  String username = "testuser1";
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  return Scaffold(
    //backgroundColor: styles.getBackgroundColor(),
    appBar: AppBar(
        title: Text("Account", style: styles.getHeadingStyle(Colors.white)),
        backgroundColor: styles.getObjectColor(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(CupertinoIcons.square_arrow_left),
            onPressed: () {},
          )
        ]),
    body: Container(
        padding: styles.getDefaultInsets(),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Column(children: [
                Row(children: [
                  Padding(
                      padding: styles.getDefaultInsets(),
                      child: Text("$username's Info",
                          style: styles.getSubHeadingStyle()))
                ]),
                FutureBuilder(
                    future: users.doc(username).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                            child: Text("Something went wrong!",
                                style: styles.getSubHeadingStyle()));
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return Center(
                            child: Text(
                                "Could not fetch data for '$username'!",
                                style: styles.getSubHeadingStyle()));
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;

                        return ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: [
                              generateUserEntry(
                                "Name",
                                CupertinoIcons.person_crop_circle_fill,
                                "${data['first_name']} ${data['last_name']}",
                                () {
                                  editNameDialog(username, data, firstNameController, lastNameController, notifyParent);
                                }
                              ),
                              generateUserEntry(
                                "Birthdate",
                                CupertinoIcons.calendar,
                                formatTimestamp((data['birthdate'] as Timestamp).toDate()),
                                () {
                                  editBirthdateDialog(username, data, notifyParent);
                                })
                            ]);
                      }

                      return Center(
                          child: Text("Loading...",
                              style: styles.getSubHeadingStyle()));
                    })
              ]),
            )
          ],
        )));
}
