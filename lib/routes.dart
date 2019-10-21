import 'package:flutter/material.dart';
import 'package:geople/screens/home/index.dart';
import 'package:geople/screens/sign_in/index.dart';
import 'package:geople/screens/sign_up/index.dart';

abstract class Routes {
  static const HOME = '/home';
  static const SIGN_IN = '/sign_in';
  static const SIGN_UP = '/sign_up';
  static const PROFILE = '/profile';
  static const SETTINGS = '/settings';
}

final routes = <String, WidgetBuilder> {
  '/home': (BuildContext context) => HomeScreen(),
  '/sign_in': (BuildContext context) => LoginScreen(),
  '/sign_up': (BuildContext context) => RegisterScreen(),
// Todo:  '/profile': (BuildContext context) => ProfileScreen(),
// Todo:  '/settings': (BuildContext context) => SettingsScreen(),
};