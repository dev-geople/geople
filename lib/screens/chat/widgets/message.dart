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
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2),
            child: Container(
              constraints: BoxConstraints(maxWidth: 270),
              child: Material(
                  color: message.from == Message.ME
                    ? Theme.of(context).cardColor
                    : Colors.lightBlueAccent,
                  elevation: 2,
                  borderOnForeground: true,
                  borderRadius: message.from == Message.ME
                      ? BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.zero,
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )
                      : BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.zero,
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Text(message.message, style: Theme.of(context).textTheme.body1,),
                  )
              ),
            ),
        )
      ]
    );
  }
}