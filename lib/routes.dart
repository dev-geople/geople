import 'package:flutter/material.dart';
import 'package:geople/screens/home/index.dart';
import 'package:geople/screens/login/index.dart';

final routes = <String, WidgetBuilder> {
  '/home': (BuildContext context) => HomeScreen(),
  '/login': (BuildContext context) => LoginScreen(),
// Todo:  '/profile': (BuildContext context) => ProfileScreen(),
// Todo:  '/settings': (BuildContext context) => SettingsScreen(),
};