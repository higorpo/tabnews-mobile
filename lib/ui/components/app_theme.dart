import 'package:flutter/material.dart';

ThemeData makeAppTheme() {
  const primaryColor = Color.fromRGBO(136, 14, 79, 1);
  const primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
  const primaryColorLight = Color.fromRGBO(188, 71, 123, 1);
  const secondaryColorDark = Color.fromRGBO(0, 37, 26, 1);

  return ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    accentColor: primaryColor,
    backgroundColor: Colors.white,
    secondaryHeaderColor: secondaryColorDark,
    textTheme: TextTheme(
      headline1: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: primaryColorDark,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColorLight),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      alignLabelWithHint: true,
    ),
    buttonTheme: ButtonThemeData(
      colorScheme: ColorScheme.light(primary: primaryColor),
      buttonColor: primaryColor,
      splashColor: primaryColorLight,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}
