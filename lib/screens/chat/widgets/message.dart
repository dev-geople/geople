import 'package:flutter/material.dart';

class Message extends StatelessWidget{
  Message({this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Text(message),
    );
  }
}