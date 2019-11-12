import 'package:flutter/material.dart';
import 'package:geople/screens/debug/index.dart';
import 'package:geople/screens/home/index.dart';
import 'package:geople/screens/profile/index.dart';
import 'package:geople/screens/sign_in/index.dart';
import 'package:geople/screens/sign_up/index.dart';

abstract class Routes {
  static const HOME = '/home';
  static const SIGN_IN = '/sign_in';
  static const SIGN_UP = '/sign_up';
  static const PROFILE = '/profile';
  static const SETTINGS = '/settings';
  static const DEBUG = '/debug';
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.HOME:
      return MaterialPageRoute(builder: (context) => HomeScreen());
    case Routes.SIGN_IN:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case Routes.SIGN_UP:
      return MaterialPageRoute(builder: (contexr) => RegisterScreen());
    case Routes.DEBUG:
      return MaterialPageRoute(builder: (contexr) => DebugScreen());
    case Routes.PROFILE:
      var uid = settings.arguments;
      return MaterialPageRoute(builder: (context) => ProfileScreen(uid: uid));
    default:
      return MaterialPageRoute(builder: (context) => HomeScreen());
  }
}

final routes = <String, WidgetBuilder>{
  '/home': (BuildContext context) => HomeScreen(),
  '/sign_in': (BuildContext context) => LoginScreen(),
  '/sign_up': (BuildContext context) => RegisterScreen(),
  '/debug': (BuildContext context) => DebugScreen(),
// Todo:  '/profile': (BuildContext context) => ProfileScreen(),
// Todo:  '/settings': (BuildContext context) => SettingsScreen(),
};
