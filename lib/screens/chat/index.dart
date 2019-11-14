import 'package:flutter/material.dart';
import 'package:geople/screens/chat/widgets/message.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.uid});
  final String uid;

  @override
  State<StatefulWidget> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  String _recepientToken;

  List<Message> _messages = [
    Message(
      message: 'ayyyy',
    ),
    Message(
      message: 'eey',
    )
  ];

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('chat'),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            new Divider(
              height: 1.0,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 5,
              ),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                      child:TextField(
                        minLines: 1,
                        maxLines: 5,
                        style: TextStyle(fontSize: 18),
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Text', //Todo: Übersetzen
                          contentPadding: EdgeInsets.only(
                              top: 5,
                              bottom: 10,
                          ),
                        ),
                      )
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)
                    ),
                    onPressed: (this._recepientToken == null)
                      ?() {

                      }
                      : null,
                    child: (this._recepientToken == null)
                      ? Icon(Icons.send)
                      : SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                      )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
