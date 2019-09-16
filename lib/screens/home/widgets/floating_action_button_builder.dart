import 'package:flutter/material.dart';

Widget buildFABForTab(int index, Function onTap) {
  /// Wenn der Tab-Index des Hauptmenus 0 ist (Kartenansicht), Wird der
  /// FloatingActionButton für den Nachrichtenbroadcast zurückgegeben.
  return index == 0
      ? FloatingActionButton(
      shape: StadiumBorder(),
      onPressed: onTap,
      backgroundColor: Colors.redAccent,
      child: Icon(
        Icons.message,
        size: 20.0,
      ))
      : null;
}