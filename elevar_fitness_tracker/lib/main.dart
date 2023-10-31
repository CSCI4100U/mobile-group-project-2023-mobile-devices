/*
 Top level functionality of our app, will include all predefined routes
*/
import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/home_page/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elevar',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(),

      // define routes here ...

    );
  }
}
