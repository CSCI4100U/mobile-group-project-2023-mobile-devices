/*
  This file returns the encapsulating body widget for the Home page
*/
import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';

Widget homeBody() {
  AppStyles styles = AppStyles();

  return Center(
    child: Text(
      "This is the Home page",
      style: styles.getHeadingStyle(),
    ),
  );
}