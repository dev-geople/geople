import 'package:flutter/material.dart';
import 'package:geople/screens/chat/arguments.dart';
import 'package:geople/screens/chat/index.dart';
import 'package:geople/screens/debug/index.dart';
import 'package:geople/screens/home/index.dart';
import 'package:geople/screens/profile/index.dart';
import 'package:geople/screens/settings/index.dart';
import 'package:geople/screens/sign_in/index.dart';
import 'package:geople/screens/sign_up/index.dart';

abstract class Routes {
  static const HOME = '/home';
  static const SIGN_IN = '/sign_in';
  static const SIGN_UP = '/sign_up';
  static const PROFILE = '/profile';
  static const SETTINGS = '/settings';
  static const CHAT = '/chat';
  static const DEBUG = '/debug';
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.HOME:
      return MaterialPageRoute(builder: (context) => HomeScreen());
    case Routes.SIGN_IN:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case Routes.SIGN_UP:
      return MaterialPageRoute(builder: (context) => RegisterScreen());
    case Routes.DEBUG:
      return MaterialPageRoute(builder: (context) => DebugScreen());
    case Routes.CHAT:
      ChatScreenArguments arguments = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => ChatScreen(arguments: arguments));
    case Routes.PROFILE:
      var uid = settings.arguments;
      return MaterialPageRoute(builder: (context) => ProfileScreen(uid: uid));
    case Routes.SETTINGS:
      return MaterialPageRoute(builder: (context) => SettingsScreen());
    default:
      // return MaterialPageRoute(builder: (context) => HomeScreen());
      return null;
  }
}
