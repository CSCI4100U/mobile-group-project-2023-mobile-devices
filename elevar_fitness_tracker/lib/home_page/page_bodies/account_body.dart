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

class AccountBody extends StatefulWidget {
  AccountBody({super.key});

  @override
  State<AccountBody> createState() => _AccountBodyState();
}

class _AccountBodyState extends State<AccountBody> {
  AppStyles styles = AppStyles();
  
  String formatTimestamp(DateTime date) {
    return "${date.year.toString()}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
  }

  void editNameDialog(BuildContext context, String username, Map<String, dynamic> data, TextEditingController firstNameController, TextEditingController lastNameController) {
    firstNameController.text = data['first_name'];
    lastNameController.text = data['last_name'];
  
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
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
                Navigator.pop(ctx);              
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

                setState(() { });
                Navigator.pop(ctx);   
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Updated name to \"${firstNameController.text} ${lastNameController.text}\"")
                  )
                );      
              }
            )
          ],
        );
      }
    );
  }

  void editBirthdateDialog(BuildContext context, String username, Map<String, dynamic> data) async {
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

      setState(() { });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Updated birthdate to \"${formatTimestamp(Timestamp.fromDate(picked).toDate())}\"")
        )
      );      
    } 
  }

  void editEmailDialog(BuildContext context, String email, Map<String, dynamic> data) async {

  }

  ListTile generateUserEntry(String entryName, IconData? icon, String text, Function() onPress, [bool? hideText]) {
    return ListTile(
      leading: Tooltip(
        message: entryName,
        child: Icon(icon)
      ),
      title: Text((hideText == null) ? text : '*' * text.length, style: styles.getSubHeadingStyle()),
      trailing: IconButton(
        icon: const Icon(CupertinoIcons.pencil),
        onPressed: () {
          onPress();
        },
      ),
      contentPadding: const EdgeInsets.only(left: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    String username = "testuser1";
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();

    return Scaffold(
      backgroundColor: styles.getBackgroundColor(),
      appBar: AppBar(
          title: Text("Account", style: styles.getHeadingStyle(Colors.white)),
          backgroundColor: styles.getObjectColor(),
          actions: <Widget>[
            IconButton(
              icon: const Icon(CupertinoIcons.square_arrow_left),
              onPressed: () {},
            )
          ]),
      body: FutureBuilder(
        future: users.doc(username).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong!",
              style: styles.getSubHeadingStyle())
            );
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Center(
              child: Text(
                "Could not fetch data for '$username'!",
                style: styles.getSubHeadingStyle()
              )
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            return Column(
              children: [
                Container(
                  margin: styles.getDefaultInsets(),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: const Color.fromARGB(255, 211, 211, 211)),
                    color: styles.getBackgroundColor()
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: styles.getDefaultInsets(),
                            child: CircleAvatar(
                              backgroundColor: Colors.yellow,
                              minRadius: 40,
                              child: Text("${data['first_name'][0]}${data['last_name'][0]}", style: styles.getSubHeadingStyle())
                            )
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              child: Text(
                                username,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic
                                )
                              )
                            )
                          )
                        ]
                      ),
                      ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          generateUserEntry(
                            "Name",
                            CupertinoIcons.person_crop_circle_fill,
                            "${data['first_name']} ${data['last_name']}",
                            () {
                              editNameDialog(context, username, data, firstNameController, lastNameController);
                            }
                          ),
                          generateUserEntry(
                            "Birthdate",
                            CupertinoIcons.calendar,
                            formatTimestamp((data['birthdate'] as Timestamp).toDate()),
                            () {
                              editBirthdateDialog(context, username, data);
                            }
                          ),
                        ]
                      )
                    ]
                  )
                ),
                Container(
                  margin: styles.getDefaultInsets(),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: const Color.fromARGB(255, 211, 211, 211)),
                    color: styles.getBackgroundColor()
                  ),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      generateUserEntry(
                        "E-mail",
                        CupertinoIcons.mail_solid,
                        "${data['email']}",
                        () {
                          
                        }
                      ),
                      generateUserEntry(
                        "Password",
                        CupertinoIcons.lock_fill,
                        "${data['password']}",
                        () {
                          
                        },
                        true
                      )
                    ],
                  )
                )
              ]
            );
          }

          return Center(
            child: Text("Loading...", style: styles.getSubHeadingStyle())
          );
        },
      )
    );
  }
}