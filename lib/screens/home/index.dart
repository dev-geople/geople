import 'package:flutter/material.dart';
import 'package:geople/screens/home/widgets/floating_action_button_builder.dart';
import 'package:toast/toast.dart';
import 'package:geople/screens/home/pages/exports.dart';


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
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(

          /// Hier wird auf das Attribut des stateful Widgets zugegriffen.
          title: Text(widget._title),
          bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(icon: Icon(Icons.map)),
                Tab(icon: Icon(Icons.chat)),
                Tab(icon: Icon(Icons.people)),
              ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            MapPage(),
            ChatsPage(),
            FriendsPage(),
          ],
        ),
        floatingActionButton: buildFABForTab(
            _tabController.index,
            _broadcastMessage
        ),
      ),
    );
  }

  _broadcastMessage() {
    Toast.show(
        _tabController.index.toString(),
        context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.BOTTOM
    );
    this.setState(() {});
  }
}
