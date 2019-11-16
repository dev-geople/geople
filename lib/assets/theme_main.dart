import 'package:flutter/material.dart';

final _primary = Colors.pink;
final _accent = Colors.green;

final lightTheme = ThemeData(
  backgroundColor: Colors.black12,
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
    )
  ),

  buttonTheme: ButtonThemeData(
    buttonColor: _primary,
    textTheme: ButtonTextTheme.primary,
    splashColor: Colors.pinkAccent,
  ),
  primarySwatch: _primary,
  accentColor: _accent,
);
