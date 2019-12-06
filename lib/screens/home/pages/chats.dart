import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geople/app_localizations.dart';
import 'package:geople/model/Message.dart';
import 'package:geople/repositories/local/messages_repository.dart';
import 'package:geople/router.dart';
import 'package:geople/screens/chat/arguments.dart';
import 'package:geople/widgets/user_tile.dart';

//Todo: Wenn Nachricht rein kommt, aktualisieren.
class ChatsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatsPageState();
  }
}

class _ChatsPageState extends State<ChatsPage> {
  bool _noMessages = false;
  List<UserTileLastMessage> _chats = List<UserTileLastMessage>();

  @override
  void initState() {
    _getChatsList().then((messages) => _initChatList(messages));
    super.initState();
  }

  void _initChatList(List<Message> list) {
    _chats.clear();
    if (list != null) {
      list.forEach((e) {
        print(e.toString());
        _chats.add(UserTileLastMessage(
          lastMessage: e,
          onDeletePressed: () {
            Navigator.of(context).pushNamed(Routes.CHAT,
                arguments:
                    ChatScreenArguments(uid: e.chatPartner, deleteChat: true));
          },
        ));
      });
    }
    if (this.mounted)
      setState(() {
        _noMessages = (list == null);
      });
  }

  Future<List<Message>> _getChatsList() async {
    MessageRepository repo = MessageRepository();
    return await repo.getChatList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: (_chats.length > 0)
          ? ListView.builder(
              itemBuilder: (_, int index) => _chats.toList()[index],
              itemCount: _chats.length,
            )
          : ((_noMessages)
              ? Center(
                  child: Text(
                      AppLocalizations.of(context).translate('info_no_chats')),
                )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}
