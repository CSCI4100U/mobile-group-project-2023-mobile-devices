import 'package:flutter/material.dart';

// class will contain various methods to make it easy to access styles throughout the project
class AppStyles {

  TextStyle getHeadingStyle([Color? color]) {
    if (color == null) {
      return const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 32,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic
      );
    }
    else {
      return TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 32,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
        color: color,
      );
    }
  }

  TextStyle getSubHeadingStyle([Color? color]) {
    if (color == null) {
      return const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );
    }
    else {
      return TextStyle(
        fontFamily: 'Roboto',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
      );
    }
  }

  TextStyle getMainTextStyle([Color? color]) {
    if (color == null) {
      return const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );
    }
    else {
      return TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
      );
    }
  }

  Color getBackgroundColor() {
    return const Color(0XFFFAFAFA);
  }

  Color getObjectColor() {
    return const Color(0xFF444444);
  }

  Color getHighlightColor() {
    return const Color(0xFF00CCFF);
  }

  EdgeInsetsGeometry getDefaultInsets() {
    return const EdgeInsets.all(10);
  }
}