import 'package:flutter/material.dart';

Widget buildFABForTab(int index, BuildContext context, Function onTap) {
  /// Wenn der Tab-Index des Hauptmenus 0 ist (Kartenansicht), Wird der
  /// FloatingActionButton für den Nachrichtenbroadcast zurückgegeben.
  return index == 0
      ? FloatingActionButton(
      shape: StadiumBorder(),
      onPressed: onTap,
      foregroundColor: Colors.white70,
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(
        Icons.message,
        size: 20.0,
        color: Colors.white//Theme.of(context).textTheme.display1.color,
      ))
      : null;
}