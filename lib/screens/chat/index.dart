import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geople/app_localizations.dart';
import 'package:geople/model/GeopleUser.dart';
import 'package:geople/model/Message.dart';
import 'package:geople/repositories/firebase/message_repository.dart';
import 'package:geople/repositories/firebase/user_repository.dart';
import 'package:geople/router.dart';
import 'package:geople/screens/chat/arguments.dart';
import 'package:geople/screens/chat/widgets/message.dart';
import 'package:geople/services/authentication.dart';
import 'package:geople/services/geople_cloud_functions.dart';

//TODO: Beim Empfangen einer Nachricht, diese anzeigen.

class ChatScreen extends StatefulWidget {
  ChatScreen({this.arguments});

  final ChatScreenArguments arguments;

  @override
  State<StatefulWidget> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen>
    with AfterLayoutMixin<ChatScreen> {
  GeopleUser _user;
  String _myUid;
  GeopleCloudFunctions _cloudFunctions = GeopleCloudFunctions();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    UserDTO _dto = UserDTO();
    _dto.getUserDetails(widget.arguments.uid).then((snapshot) {
      if (snapshot.data != null) {
        Auth auth = Auth();
        GeopleUser user = GeopleUser();
        user.toObject(snapshot.data);
        user.uid = widget.arguments.uid;
        _user = user;
        auth.getCurrentUser().then((user) {
          setState(() {
            _myUid = user.uid;
            _user = _user;
          });
        });
      }
    });
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _showDeleteDialog();
  }

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_user != null ? _user.username : ''),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: (_user != null)
                  ? Container(
                      color: Theme.of(context).backgroundColor,
                      child: StreamBuilder(
                        stream: Firestore.instance
                            .collection('chats')
                            .document(_myUid)
                            .collection('chatlist')
                            .document(_user.uid)
                            .collection('chat-history')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return SizedBox(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate('info_no_messages'),
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                ],
                              ),
                            );
                          else
                            return ListView(
                              padding: EdgeInsets.all(8.0),
                              reverse: true,
                              children: snapshot.data.documents.map((document) {
                                Message message = Message();
                                message.toObject(document.data);
                                print(message.toString());
                                return MessageWidget(
                                  message: message,
                                  loggedUserUid: _myUid,
                                );
                              }).toList(),
                            );
                        },
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
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
                        hintText: AppLocalizations.of(context)
                            .translate('hint_write_text'),
                        contentPadding: EdgeInsets.only(
                          top: 5,
                          bottom: 10,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      onPressed: (this._user != null)
                          ? () {
                              Message msgToSend = Message(
                                  from: Message.ME,
                                  to: _user.uid,
                                  message: _controller.text,
                                  timestamp: DateTime.now().toIso8601String(),
                                  chatPartner: _user.uid);
                              _cloudFunctions.sendMessage(
                                  _user.uid, _controller.text);
                              _controller.clear();
                            }
                          : null,
                      child: (this._user != null)
                          ? Container(
                              child: SizedBox(
                                height: 25,
                                width: 25,
                                child: Icon(Icons.send),
                              ),
                            )
                          : Container(
                              child: SizedBox(
                                width: 35,
                                height: 25,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                    Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteMessagesAndRedirect(BuildContext context) {
    MessageRepository repo = MessageRepository();
    repo.deleteChat(widget.arguments.uid).then((_) {
      Navigator.of(context)
          .popAndPushNamed(Routes.HOME); //Todo: Redirect to Chatlist
    });
  }

  _showDeleteDialog() {
    if (widget.arguments.deleteChat) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            AppLocalizations.of(context).translate('popup_title_delete'),
          ),
          content: Text(
            AppLocalizations.of(context).translate('popup_body_delete'),
          ),
          actions: <Widget>[
            FlatButton(
                child: Text(
                  AppLocalizations.of(context).translate('no'),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            FlatButton(
              child: Text(
                AppLocalizations.of(context).translate('yes'),
              ),
              onPressed: () {
                _deleteMessagesAndRedirect(this.context);
              },
            ),
          ],
        ),
      );
    }
  }
}
