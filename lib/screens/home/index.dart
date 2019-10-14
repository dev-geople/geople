import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

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
class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Tabs initialisieren
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          ///
          actions: <Widget>[
            MeatballMenuMain(),
          ],
          /// Hier wird auf das Attribut des Widgets('widget') zugegriffen.
          title: Text(widget._title),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            MapPage(),
            ChatsPage(),
            FriendsPage(),
          ],
        ),
        resizeToAvoidBottomPadding: true,
        bottomNavigationBar:  TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.map) ),
              Tab(icon: Icon(Icons.chat)),
              Tab(icon: Icon(Icons.people)),
            ]),
        floatingActionButton: buildFABForTab(
            _tabController.index,
            _broadcastMessage
        ),
      ),
    );
  }

  /// TabController sauber löschen.
  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  /// State bei einem TabIndex-Wechsel neu laden.
  void _handleTabIndex() {
    setState(() {});
  }

  // Todo: implement message broadcast.
  _broadcastMessage() {
    Toast.show(
        'MESSAGE BROADCASTING YET TO BE IMPLEMENTED!',
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM
    );
    this.setState(() {});
  }
}
