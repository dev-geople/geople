import 'package:flutter/material.dart';
import 'package:geople/app_localizations.dart';
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
  List<FriendTile> _friends = List<FriendTile>();
  @override
  void initState() {
    FriendsRepository repo = FriendsRepository();
    repo.getFriends().then((map) {
      map.forEach((uid, pending) {
        _friends.add(FriendTile(
          uid: uid,
          pending: pending,
        ));
      });
      setState(() {
        if (_friends.length <= 0) _noFriends = true;
      });
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
                ? Center(
                    child: Text(
                      AppLocalizations.of(context).translate('info_no_friends'),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  )));
  }
}
