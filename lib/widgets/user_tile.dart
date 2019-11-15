import 'package:flutter/material.dart';
import 'package:geople/model/GeopleUser.dart';

import '../router.dart';

class UserTile extends StatelessWidget {
  UserTile({@required this.user});

  final GeopleUser user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.PROFILE, arguments: user.uid);
      },
      title: Text(user.username??''),
      subtitle: Text(user.status??''),
      trailing: IconButton(
          icon: Icon(Icons.chat),
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.CHAT, arguments: user.uid);
          },
      ),
    );
  }
}