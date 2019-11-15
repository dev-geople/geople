import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geople/model/Message.dart';

class MessageWidget extends StatelessWidget{
  MessageWidget({this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: message.from == Message.ME
        ? MainAxisAlignment.end
        : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: message.from == Message.ME
              ? BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.zero,
              topLeft: Radius.circular(100),
              topRight: Radius.circular(100),
            ),
            color: Colors.green,
          )
              : BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.zero,
              bottomRight: Radius.circular(100),
              topLeft: Radius.circular(100),
              topRight: Radius.circular(100),
            ),
            color: Colors.red,
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Text(message.message, ),
        ),
      ]
    );
  }
}