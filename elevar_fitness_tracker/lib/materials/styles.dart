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

  /*
   *
   * NEW STYLES UNDER HERE!
   * (keeping the old stuff above for now until all pages are updated)
   * 
   */

  // Note about these colour codes:
  // If you ever need to change the opacity, USE THE withOpacity() method!
  // Example: AppStyles.accentColor(isDarkMode).withOpacity(0.5) for accentColor
  // with half opacity.

  static Color textColor(bool darkMode) {
    return darkMode ? const Color(0xfffbf4f6) : const Color(0xff0b0406);
  }

  static Color backgroundColor(bool darkMode) {
    return darkMode ? const Color(0xff040102) : const Color(0xfffefbfc);
  }

  static Color primaryColor(bool darkMode) {
    return darkMode ? const Color(0xff30917b) : const Color(0xff6ecfb8);
  }

  static Color secondaryColor(bool darkMode) {
    return darkMode ? const Color(0xff4b4425) : const Color(0xfff9ebbe);
  }

  static Color accentColor(bool darkMode) {
    return darkMode ? const Color(0xff788e9b) : const Color(0xff647a87);
  }
}

// This method lets you create a color from a string representing a hex code,
// I honestly don't remember what I was using it for, but maybe it'll be useful
// to someone else eventually.
// If a hex code without alpha is provided, it defaults to 255.
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "ff$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}