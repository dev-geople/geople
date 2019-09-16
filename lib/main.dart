import 'package:flutter/material.dart';
import 'package:geople/screens/home/index.dart';

void main() => runApp(Geople());

/// Dieses Widget ist der Stamm (root) der App.
class Geople extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      title: 'Geople',
      theme: ThemeData(
        primaryColor: Colors.white, // Das 'Theme' der App.
      ),
      home: HomeScreen(),
      supportedLocales: [
        const Locale('en'), // English
        const Locale('de'), // German
      ],
    );
  }
}
