import 'package:flutter/material.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(102, 2, 0, .1),
  100: Color.fromRGBO(102, 2, 0, .2),
  200: Color.fromRGBO(102, 2, 0, .3),
  300: Color.fromRGBO(102, 2, 0, .4),
  400: Color.fromRGBO(102, 2, 0, .5),
  500: Color.fromRGBO(102, 2, 0, .6),
  600: Color.fromRGBO(102, 2, 0, .7),
  700: Color.fromRGBO(102, 2, 0, .8),
  800: Color.fromRGBO(102, 2, 0, .9),
  900: Color.fromRGBO(102, 2, 0, 1),
};

Map<int, Color> accent = {
  50: Color.fromRGBO(230, 195, 162, .1),
  100: Color.fromRGBO(230, 195, 162, .2),
  200: Color.fromRGBO(230, 195, 162, .3),
  300: Color.fromRGBO(230, 195, 162, .4),
  400: Color.fromRGBO(230, 195, 162, .5),
  500: Color.fromRGBO(230, 195, 162, .6),
  600: Color.fromRGBO(230, 195, 162, .7),
  700: Color.fromRGBO(230, 195, 162, .8),
  800: Color.fromRGBO(230, 195, 162, .9),
  900: Color.fromRGBO(230, 195, 162, 1),
};

final _primary = MaterialColor(color[900].hashCode, color);
final _accent = MaterialColor(accent[900].hashCode, accent);
final _splashColor = _primary[300];

final lightTheme = ThemeData(
  backgroundColor: _accent[400],
  textTheme: TextTheme(
    button: TextStyle(
      fontSize: 16,
    ),
  ),
  appBarTheme: AppBarTheme(
      //Todo: AppBarTheme
      ),
  tabBarTheme: TabBarTheme(
      labelColor: Colors.black,
      indicator: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(
            color: _primary,
            width: 5,
          ),
        ),
      )),
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(splashColor: _splashColor),
  buttonTheme: ButtonThemeData(
    buttonColor: _primary,
    textTheme: ButtonTextTheme.primary,
    splashColor: _primary[200],
  ),
  primarySwatch: _primary,
  accentColor: _accent,
  primaryTextTheme: TextTheme(
    display1: TextStyle(
      color: _splashColor,
    ),
  ),
);
