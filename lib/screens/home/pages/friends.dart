import 'package:flutter/material.dart';
import 'package:geople/model/GeopleUser.dart';
import 'package:geople/repositories/firebase/friends_repository.dart';
import 'package:geople/widgets/user_tile.dart';

class FriendsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FriendsPageState();
  }
}

class _FriendsPageState extends State<FriendsPage> {
  bool _noFriends = false;
  List<UserTile> _friends = List<UserTile>();
  @override
  void initState() {
    FriendsRepository repo = FriendsRepository();
    repo.getFriends().then((list) {
      list.forEach((uid) {
        _friends.add(UserTile(uid: uid));
      });
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: (_friends.length > 0)
          ? ListView.builder(
        itemBuilder: (_, int index) => _friends.toList()[index],
        itemCount: _friends.length,
      )
          : ((_noFriends)
          ? Center(child: Text('no messages',)) //Todo: translate ("info_no_chats");
          : Center(child: CircularProgressIndicator(),))
    );
  }
}
