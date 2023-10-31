/*
  This file returns the encapsulating body widget for the Account page
*/
import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';

Widget accountBody() {
  AppStyles styles = AppStyles();

  return Center(
    child: Text(
      "This is the Account page",
      style: styles.getHeadingStyle(),
    ),
  );
}