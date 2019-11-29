import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geople/services/authentication.dart';

import '../router.dart';

class MeatballMenuMain extends StatelessWidget {
  MeatballMenuMain({this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Choice>(
      icon: Icon((Platform.isIOS) ? Icons.more_horiz : Icons.more_vert,
        color: Theme.of(context).primaryColor,),
      /// Wenn auf eines der Menuitems getappt wird, wird diese Methode
      /// aufgerufen und als wert die Choice mitgegeben.
      onSelected: _onSelectMenu,
      itemBuilder: (BuildContext context) {
        /// Jedes Element wird durchgegangen und für jedes Element wird
        /// ein PopupMenuItem zurückgegeben.
        return choices.map((Choice choice) {
          /// Die einzelnen Menuitems zurückgeben.
          return PopupMenuItem<Choice>(
            value: choice,
            child: Text(choice.title),
          );
        }).toList();
      },
    );
  }

  void _onSelectMenu(Choice choice) {
    //TOdo: REMOVE
    if(choice.route == Routes.PROFILE) {
      Auth _auth = new Auth();
      _auth.getCurrentUser().then((user){
        Navigator.of(context).pushNamed(choice.route, arguments: user.uid);
      });
      return;
    }
    //Todo: remove
    if(choice.route == '/sign_out') {
      Auth _auth = Auth();
      _auth.signOut();
      Navigator.of(context).pushReplacementNamed(Routes.SIGN_IN);
      return;
    }

    /// Router
    if (ModalRoute.of(context).settings.name != choice.route)
      Navigator.of(context).pushNamed(choice.route);
  }
}

/// ModelKlasse für die wählbaren Menuitems.
class Choice {
  const Choice({this.title, this.route});

  final String title;
  final String route;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Profile', route: Routes.PROFILE),
  const Choice(title: 'Settings', route: Routes.SETTINGS),
  const Choice(title: 'Logout', route: '/sign_out'),
  const Choice(title: '{DEBUG}', route: '/debug'),
];
