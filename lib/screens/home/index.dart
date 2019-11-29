 import 'package:flutter/material.dart';
import 'package:geople/screens/home/widgets/bottom_app_bar.dart';
import 'package:geople/services/authentication.dart';
import 'package:geople/services/notification_manager.dart';

import 'package:geople/screens/home/widgets/floating_action_button_builder.dart';
import 'package:geople/screens/home/pages/exports.dart';
import 'package:geople/widgets/meatball_menu_main.dart';


/// Widget für die Homepage der App. Sie ist 'Stateful' was bedeutet, dass es
/// ein Stateobjekt benötigt (Hier eine Instanz der _HomePageState Klasse),
/// welche Attribute enthält, wie das Widget aussieht.
/// Attribute in dieser Klasse sind immer 'final'!
class HomeScreen extends StatefulWidget {
  final _title = 'Geople';

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

/// Diese Klasse ist die Konfiguration für das State. Es enthält Werte (In
/// diesem Fall 'title') welches es von dem Elternobjekt bekommt. Diese Werte
/// werden dann in der build methode des States benutzt.
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final _notificationManager = NotificationService();
    _notificationManager.init();
  }


  @override
  Widget build(BuildContext context) {
    /// Prüft, ob der User eingeloggt ist und leitet ihn auf die Login-Seite um
    /// falls nicht.
    Auth _auth = Auth();
    _auth.ensureIsLoggedIn(context);

    return SafeArea(
      top: _safeZoneTop(),
      bottom: true,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildCurrentPage(),
        resizeToAvoidBottomPadding: true,
        bottomNavigationBar: GeopleBottomAppBar(
          onTabSelected: _selectedTab,
          selectedTabColor: Theme.of(context).primaryColor,
          items: [
            GeopleBottomAppBarItem(
              iconData: Icons.map, text: 'Map'
            ),
            GeopleBottomAppBarItem(
                iconData: Icons.chat, text: 'Chat'
            ),
            GeopleBottomAppBarItem(
                iconData: Icons.people, text: 'Friends'
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //Todo: zu Map
          },
          child: Icon(Icons.add_comment),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        )
      ),
    );
  }

  /// TabController sauber löschen.
  @override
  void dispose() {
    super.dispose();
  }

  _buildCurrentPage() {
    switch(_currentIndex){
      case 0: return MapPage();
      case 1: return ChatsPage();
      case 2: return FriendsPage();
      default: return MapPage();
    }
  }

  _buildAppBar(){
    switch(_currentIndex){
      case 0: return null;
      default: return AppBar(
        actions: <Widget>[
          MeatballMenuMain(context: this.context,),
        ],
        /// Hier wird auf das Attribut des Widgets('widget') zugegriffen.
        title: Text(widget._title),
      );
    }
  }

  bool _safeZoneTop(){
    switch(_currentIndex){
      case 0: return true;
      default: return false;
    }
  }

  _selectedTab(int i) {
    setState(() {
      _currentIndex = i;
    });
  }
}
