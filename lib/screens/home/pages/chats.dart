import 'package:flutter/material.dart';
import 'package:geople/repositories/local/messages_repository.dart';
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
    MessageRepository repo = MessageRepository();
    repo.getChatList().then((list) {
      if (list != null) {
        _chats.clear();
        list.forEach((e) {
          _chats.add(UserTileLastMessage(
            lastMessage: e,
          ));
        });
      }
      if(this.mounted) setState(() {_noMessages = (list == null);});
    });
    super.initState();
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
          ? Center(child: Text('no messages'),) //Todo: translate ("info_no_chats");
          : Center(child: CircularProgressIndicator(),)),
    );
  }
}
