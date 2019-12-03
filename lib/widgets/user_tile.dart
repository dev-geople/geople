import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:geople/model/GeopleUser.dart';
import 'package:geople/model/Message.dart';
import 'package:geople/repositories/local/messages_repository.dart';
import 'package:geople/screens/chat/arguments.dart';
import 'package:geople/repositories/firebase/user_repository.dart';
import 'package:geople/services/geople_cloud_functions.dart';
import 'package:geople/widgets/profile_picture.dart';
import 'package:intl/intl.dart';

import '../app_localizations.dart';
import '../router.dart';

/// ================================
/// ========= USER TILE
class UserTile extends StatefulWidget {
  UserTile({@required this.uid});

  final String uid;

  @override
  State<StatefulWidget> createState() => _UserTileState(uid);
}

class _UserTileState extends State<UserTile> {
  _UserTileState(this._uid);

  String _uid;
  GeopleUser user;

  @override
  void initState() {
    UserDTO dto = UserDTO();
    dto.getGeopleUser(_uid).then((geopleUser) {
      if (this.mounted)
        setState(() {
          this.user = geopleUser;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return Material(
        color: Theme.of(context).cardColor,
        elevation: 3,
        child: ListTile(
          onTap: () {
            if (user != null)
              Navigator.of(context).pushNamed(Routes.PROFILE, arguments: _uid);
          },
          leading: ProfilePictureSmall(
              imageUrl:
                  'https://lakewangaryschool.sa.edu.au/wp-content/uploads/2017/11/placeholder-profile-sq.jpg'),
          title: Text(user.username ?? ''),
          subtitle: Row(
            children: <Widget>[Text(user.status ?? '')],
          ),
          trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                print('delete friend'); //Todo: remove friend
              }),
        ),
      );
    }
    return Text('');
  }
}

/// ================================
/// ========= USER TILE FOR FRIENDSLIST
class FriendTile extends StatefulWidget {
  FriendTile({@required this.uid, @required this.pending});

  final bool pending;
  final String uid;

  @override
  State<StatefulWidget> createState() =>
      _FriendTileState(uid: uid, pending: pending);
}

class _FriendTileState extends State<FriendTile> {
  _FriendTileState({this.uid, this.pending});

  final String uid;
  final bool pending;
  GeopleUser user;
  GeopleCloudFunctions cloudFunctions;

  @override
  void initState() {
    cloudFunctions = new GeopleCloudFunctions();
    UserDTO dto = UserDTO();
    dto.getGeopleUser(uid).then((geopleUser) {
      if (this.mounted)
        setState(() {
          this.user = geopleUser;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return Material(
        color: (pending) ? Theme.of(context).accentColor :Theme.of(context).cardColor,
        elevation: 3,
        child: ListTile(
          onTap: () {
            if (user != null)
              Navigator.of(context).pushNamed(Routes.PROFILE, arguments: uid);
          },
          leading: ProfilePictureSmall(
              imageUrl:
                  'https://lakewangaryschool.sa.edu.au/wp-content/uploads/2017/11/placeholder-profile-sq.jpg'),
          title: Text(user.username ?? ''),
          subtitle: Row(
            children: <Widget>[Text(user.status ?? '')],
          ),
          trailing: (pending)
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        cloudFunctions.confirmFriendRequest(uid);
                        //TODO  aktualisieren
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        print('refuse friend'); //Todo: remove friend
                      },
                    )
                  ],
                )
              : IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    print('delete friend'); //Todo: remove friend
                  }),
        ),
      );
    }
    return Text('');
  }
}

/// ================================
/// ========= USER TILE FOR CHATLIST
class UserTileLastMessage extends StatefulWidget {
  UserTileLastMessage(
      {@required this.lastMessage, @required this.onDeletePressed});

  final Message lastMessage;
  final Function onDeletePressed;

  @override
  State<StatefulWidget> createState() =>
      _UserTileLastMessageState(lastMessage, onDeletePressed);
}

class _UserTileLastMessageState extends State<UserTileLastMessage> {
  _UserTileLastMessageState(this._lastMessage, this._onDeletePressed);

  Function _onDeletePressed;
  Message _lastMessage;
  GeopleUser user;

  @override
  void initState() {
    UserDTO dto = UserDTO();
    dto
        .getGeopleUser(_lastMessage.from != Message.ME
            ? _lastMessage.from
            : _lastMessage.to)
        .then((geopleUser) {
      if (this.mounted)
        setState(() {
          this.user = geopleUser;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return Material(
        color: Theme.of(context).cardColor,
        elevation: 3,
        child: ListTile(
          onTap: () {
            if (user != null)
              Navigator.of(context).pushNamed(Routes.CHAT,
                  arguments: ChatScreenArguments(
                      uid: _lastMessage.chatPartner, deleteChat: false));
          },
          leading: ProfilePictureSmall(
              imageUrl:
                  'https://lakewangaryschool.sa.edu.au/wp-content/uploads/2017/11/placeholder-profile-sq.jpg'),
          title: Text(user.username ?? ''),
          subtitle: Row(
            children: <Widget>[
              Text(_lastMessage.from == Message.ME
                  ? AppLocalizations.of(context).translate('you') ?? ''
                  : ''),
              Text('(' +
                  DateFormat('dd.MM. kk:mm')
                      .format(DateTime.parse(_lastMessage.timestamp)) +
                  '): '),
              Text(' ' + _lastMessage.message),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.close),
            onPressed: _onDeletePressed,
          ),
        ),
      );
    }
    return Text('');
  }
}
