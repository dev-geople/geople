import 'package:flutter/material.dart';
import 'package:geople/model/GeopleUser.dart';
import 'package:geople/model/Message.dart';
import 'package:geople/repositories/local/messages_repository.dart';
import 'package:geople/screens/chat/widgets/message.dart';
import 'package:geople/services/geople_cloud_functions.dart';
import 'package:geople/services/user_dto.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.uid});

  final String uid;

  @override
  State<StatefulWidget> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  GeopleUser _user;
  GeopleCloudFunctions _cloudFunctions = GeopleCloudFunctions();
  MessageRepository _messageRepository = MessageRepository();

  List<MessageWidget> _messages = [
    MessageWidget(
      message: Message(
        message: 'This is my first Message',
        from: Message.ME,
      ),
    ),
    MessageWidget(
      message: Message(
        message: 'next one',
        from: 'sdoaihbnfiuasdhd',
      ),
    )
  ];

  @override
  void initState() {
    UserDTO _dto = UserDTO();
    _dto.getUserDetails(widget.uid).then((snapshot) {
      if (snapshot.data != null) {
        GeopleUser user = GeopleUser();
        user.toObject(snapshot.data);
        setState(() {
          _user = user;
        });
      }
    });
    super.initState();
  }

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_user!=null ? _user.username : ''),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) =>
                    _messages.reversed.toList()[index],
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                      child: TextField(
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
                  )),
                  SizedBox(
                    width: 50,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      onPressed: (this._user != null)
                          ? () {
                        _cloudFunctions.sendMessage(_user.uid, _controller.text);
                        _messageRepository.saveMessage(
                            Message(
                              from: Message.ME,
                              to: _user.uid,
                              message: _controller.text,
                              timestamp: DateTime.now().toIso8601String(),
                            ));
                      }
                          : null,
                        child: (this._user != null)
                            ? Container(
                                  color: Colors.amber,
                                  child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: Icon(Icons.send),
                                  ),
                                )
                            : Container(
                                color: Colors.red,
                                child: SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      Theme.of(context).primaryColor,
                                    ),
                                  ),
                              ),
                        )
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
