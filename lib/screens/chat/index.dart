import 'package:flutter/material.dart';
import 'package:geople/model/GeopleUser.dart';
import 'package:geople/model/Message.dart';
import 'package:geople/repositories/local/messages_repository.dart';
import 'package:geople/screens/chat/widgets/message.dart';
import 'package:geople/services/geople_cloud_functions.dart';
import 'package:geople/services/user_dto.dart';

//TODO: Beim Empfangen einer NAchricht, diese anzeigen.

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

  List<MessageWidget> _messages = List<MessageWidget>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    UserDTO _dto = UserDTO();
    _dto.getUserDetails(widget.uid).then((snapshot) {
      if (snapshot.data != null) {
        GeopleUser user = GeopleUser();
        user.toObject(snapshot.data);
        user.uid = widget.uid;
        //Todo: onerror
        _messageRepository.getMessagesOfUser(user.uid)
            .then((messageList) {
              if(messageList != null) {
                _messages.clear();
                messageList.forEach((msg) {
                  _messages.add(MessageWidget(
                    message: msg,
                  ));
                });
              }
              setState(() {
                _user = user;
                _messages = _messages;
              });
            });
      }
    });
    super.initState();
  }

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_user!=null ? _user.username : ''),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: Container(
                color: Theme.of(context).backgroundColor,
                child: ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) =>
                  _messages.reversed.toList()[index],
                  itemCount: _messages.length,
                ),
              )
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
                        Message msgToSend = Message(
                          from: Message.ME,
                          to: _user.uid,
                          message: _controller.text,
                          timestamp: DateTime.now().toIso8601String(),
                        );

                        _cloudFunctions.sendMessage(_user.uid, _controller.text);
                        _messageRepository.saveMessage(msgToSend)
                            .then((msg) {
                              setState(() {
                                _messages.add(MessageWidget(message: msg));
                              });
                            });
                          _controller.clear();
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
