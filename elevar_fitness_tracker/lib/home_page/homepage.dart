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
  int currentIndex = 1; // the currently selected page (default is home page)
  final PageController _pageController = PageController(initialPage: 1);
  late Map pages;
  bool darkmode = false;

  void switchToPage(int index) {
    setState(() {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut
      );
    });
  }

  @override
  void initState() {
    super.initState();
    pages = {0:StatsBody(switchToPage), 1:HomeBody(switchToPage), 2:AccountBody(switchToPage)}; // the mapping of our pages for the navbar
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppStyles.backgroundColor(darkmode),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Geologica'
        ),
        selectedLabelStyle: TextStyle(
          fontFamily: 'Geologica',
          color: AppStyles.primaryColor(darkmode),
          fontWeight: FontWeight.w700
        ),
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.graph_square),
            activeIcon: Icon(CupertinoIcons.graph_square, color: AppStyles.primaryColor(darkmode)),
            label: "Stats"
          ),

          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.home),
            activeIcon: Icon(CupertinoIcons.home, color: AppStyles.primaryColor(darkmode)),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.person_fill),
            activeIcon: Icon(CupertinoIcons.person_fill, color: AppStyles.primaryColor(darkmode)),
            label: "Account",
          )
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppStyles.textColor(darkmode),
        unselectedItemColor: AppStyles.accentColor(darkmode),
        unselectedIconTheme: IconThemeData(color: AppStyles.accentColor(darkmode)),
        onTap: (value) {
          setState(() {
            currentIndex = value;

            _pageController.animateToPage(
              value,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut
            );
          });
        },
      ),

      floatingActionButton: currentIndex == 1? FloatingActionButton(
        // later somehow change the icon to a dumbell or something similar
        onPressed: () async {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WorkoutPage()),
          );
        },
        backgroundColor: AppStyles.backgroundColor(darkmode),
        focusColor: AppStyles.highlightColor(darkmode),
        tooltip: "Create a new workout",
        child: Icon(Icons.add, size: 24, color: AppStyles.textColor(darkmode)),
        /*
        const ImageIcon(
          AssetImage('lib/img/dumbell.png'),
          size: 24.0
        )
        */
      ) : null,

      //body: pages[currentIndex], // this allows the body to change on setState() call
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => currentIndex = index);
          },
          children: [
            pages[0],
            pages[1],
            pages[2]
          ]
        )
      )

    );
  }
}