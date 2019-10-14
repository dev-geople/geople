import 'package:flutter/material.dart';

import '../app_localizations.dart';

class MeatballMenuMain extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MeatballMenuMainState();
  }
}

class MeatballMenuMainState extends State<MeatballMenuMain> {

  @override
  Widget build(BuildContext context) {

    List<Choice> choices = <Choice>[
      Choice(AppLocalizations.of(context).translate('profile'), '/profile'),
      Choice(AppLocalizations.of(context).translate('settings'), '/settings'),
    ];

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
  Choice(String title, String route){
    this.title = title;
    this.route = route;
  }

  String title;
  String route;
}

