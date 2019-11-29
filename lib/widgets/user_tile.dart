import 'package:flutter/material.dart';
import 'package:geople/model/GeopleUser.dart';
import 'package:geople/model/Message.dart';
import 'package:geople/repositories/local/messages_repository.dart';
import 'package:geople/screens/chat/arguments.dart';
import 'package:geople/services/user_dto.dart';
import 'package:geople/widgets/profile_picture.dart';
import 'package:intl/intl.dart';

import '../app_localizations.dart';
import '../router.dart';

class UserTile extends StatefulWidget{
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
    dto.getGeopleUser(_uid)
        .then((geopleUser) {
      if(this.mounted) setState(() {
        this.user = geopleUser;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(user != null) {
      return Material(
        color: Theme.of(context).cardColor,
        elevation: 3,

        child: ListTile(
          onTap: () {
            if (user != null)
              Navigator.of(context).pushNamed(Routes.PROFILE, arguments: _uid);
          },
          leading: ProfilePictureSmall(imageUrl: 'https://lakewangaryschool.sa.edu.au/wp-content/uploads/2017/11/placeholder-profile-sq.jpg'),
          title: Text(user.username??''),
          subtitle: Row(
            children: <Widget>[
              Text(user.status??'')
            ],
          ),
          trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: (){
                print('delete friend'); //Todo: remove friend
              }
            ),
        ),
      );
    } return Text('');
  }
}


class UserTileLastMessage extends StatefulWidget{
  UserTileLastMessage({@required this.lastMessage, @required this.onDeletePressed});
  final Message lastMessage;
  final Function onDeletePressed;

  @override
  State<StatefulWidget> createState() => _UserTileLastMessageState(lastMessage, onDeletePressed);
}

class _UserTileLastMessageState extends State<UserTileLastMessage> {
  _UserTileLastMessageState(this._lastMessage, this._onDeletePressed);

  Function _onDeletePressed;
  Message _lastMessage;
  GeopleUser user;

  @override
  void initState() {
    UserDTO dto = UserDTO();
    dto.getGeopleUser(_lastMessage.from != Message.ME ? _lastMessage.from : _lastMessage.to)
        .then((geopleUser) {
        if(this.mounted) setState(() {
            print(geopleUser.username);
            this.user = geopleUser;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    if(user != null) {
      return Material(
        color: Theme.of(context).cardColor,
        elevation: 3,

        child: ListTile(
          onTap: () {
            if (user != null)
              Navigator.of(context).pushNamed(Routes.CHAT, arguments: ChatScreenArguments(uid: _lastMessage.chatPartner, deleteChat: false));
          },
          leading: ProfilePictureSmall(imageUrl: 'https://lakewangaryschool.sa.edu.au/wp-content/uploads/2017/11/placeholder-profile-sq.jpg'),
          title: Text(user.username??''),
          subtitle: Row(
            children: <Widget>[
              Text(_lastMessage.from == Message.ME ? AppLocalizations.of(context).translate('you')??'' : ''),
              Text('('+DateFormat('dd.MM. kk:mm').format(DateTime.parse(_lastMessage.timestamp))+'): '),
              Text(' ' + _lastMessage.message),
            ],
          ),
          trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: _onDeletePressed,
          ),
        ),
      );
    } return Text('');
  }
}