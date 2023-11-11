/*
  - This class represents the main screen sequence of the app.
  - It includes an encapsulating scaffold, with a bottom navbar taking you to one of 
  three possible screens. The Navigation of the main pages is done in place, no routes required.
  - However, we will later implement routes for adding a workout, taking you to the registration page,
  and potentially more involving the stats page
*/
import 'package:elevar_fitness_tracker/home_page/page_bodies/workout_page/workout_body.dart';
import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';
import 'package:flutter/cupertino.dart';
import 'page_bodies/home_body.dart';
import 'page_bodies/stats_body.dart';
import 'page_bodies/account_body.dart';
//import 'package:elevar_fitness_tracker/local_storage/exercises_db_model.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}


class HomePageState extends State<HomePage> {
  AppStyles styles = AppStyles(); // initializing our styles object
  int currentIndex = 0; // the currently selected page (default is home page)
  late Map pages;
  //ExerciseDBModel database = ExerciseDBModel();

  void refresh() {
    refreshAccountBody();
    setState(() {});
  }

  void refreshAccountBody() {
    pages[2] = accountBody(refresh);
  }

  HomePageState() {
    pages = {0:homeBody(), 1:statsBody(), 2:accountBody(refresh)}; // the mapping of our pages for the navbar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home, color: styles.getObjectColor(),),
            activeIcon: Icon(CupertinoIcons.home, color: styles.getHighlightColor(),),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.graph_square, color: styles.getObjectColor()),
            activeIcon: Icon(CupertinoIcons.graph_square, color: styles.getHighlightColor()),
            label: "Stats"
          ),

          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_fill, color: styles.getObjectColor()),
            activeIcon: Icon(CupertinoIcons.person_fill, color: styles.getHighlightColor()),
            label: "Account",
          )
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: styles.getHighlightColor(),
        unselectedItemColor: styles.getObjectColor(),
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),

      floatingActionButton: currentIndex == 0? FloatingActionButton(
        // later somehow change the icon to a dumbell or something similar
        onPressed: () {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WorkoutPage()),
          );
        },
        backgroundColor: styles.getBackgroundColor(),
        focusColor: styles.getHighlightColor(),
        tooltip: "Start a new workout",
        child: Icon(Icons.add, size: 24, color: styles.getObjectColor()),
        /*
        const ImageIcon(
          AssetImage('lib/img/dumbell.png'),
          size: 24.0
        )
        */
      ) : null,

      body: pages[currentIndex], // this allows the body to change on setState() call
      
    );
  }
}