import 'package:flutter/material.dart';

ThemeData makeAppTheme() {
  const primaryColor = Color.fromRGBO(36, 41, 47, 1);

  return ThemeData(
    primaryColor: primaryColor,
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      headline3: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      overline: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
        color: Color.fromRGBO(110, 119, 129, 1),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
    ),
    scaffoldBackgroundColor: const Color.fromRGBO(238, 238, 238, 1),
  );
}
