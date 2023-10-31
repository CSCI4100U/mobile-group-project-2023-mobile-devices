/*
  This file returns the encapsulating body widget for the Stats page
*/

import 'package:flutter/material.dart';
import 'package:elevar_fitness_tracker/materials/styles.dart';

Widget statsBody() {
  AppStyles styles = AppStyles();

  return Center(
    child: Text(
      "This is the Stats page",
      style: styles.getHeadingStyle(),
    ),
  );
}