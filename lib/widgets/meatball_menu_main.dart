import 'package:flutter/material.dart';

import '../routes.dart';

class MeatballMenuMain extends StatelessWidget {
  MeatballMenuMain({this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Choice>(
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
  const Choice(title: 'Login', route: Routes.SIGN_IN),
];
