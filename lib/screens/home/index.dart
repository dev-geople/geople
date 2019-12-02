import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geople/model/Location.dart';
import 'package:geople/screens/home/widgets/bottom_app_bar.dart';
import 'package:geople/services/authentication.dart';
import 'package:geople/services/geople_cloud_functions.dart';
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
class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  FocusNode _focusNode = FocusNode();
  TextEditingController _textEditingController = TextEditingController();
  Geolocator _geolocator = Geolocator();
  final key = GlobalKey<GeopleBottomAppBarState>();
  bool _textfieldShown = false;
  bool _isSending = false;
  bool _canSend = false;

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
          body: Stack(
            children: <Widget>[
              _buildCurrentPage(),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Material(
                  elevation: 5,
                  color: Colors.white,
                  child: Visibility(
                    maintainSize: false,
                    visible: _textfieldShown,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 50, bottom: 5),
                          child:  TextField(
                            maxLength: 45,
                            maxLengthEnforced: true,
                            onChanged: ((text){
                              setState(() {
                                _canSend = text.length > 0;
                              });
                            }),
                            maxLines: 1,
                            autofocus: true,
                            focusNode: _focusNode,
                            controller: _textEditingController,
                          ),
                        ),
                        (_isSending)
                            ? CircularProgressIndicator()
                            : IconButton(
                                icon: Icon((_canSend)
                                    ? Icons.send
                                    : Icons.close,
                                    color: Theme.of(context).primaryColor),
                                onPressed: () {
                                  if(_canSend){
                                    _sendAndUnfocus();
                                  } else {
                                    setState(() {
                                      _isSending = false;
                                      _textfieldShown = false;
                                    });
                                    FocusScope.of(context).unfocus();
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          resizeToAvoidBottomPadding: true,
          bottomNavigationBar: GeopleBottomAppBar(
            key: key,
            onTabSelected: _selectedTab,
            selectedTabColor: Theme.of(context).primaryColor,
            items: [
              GeopleBottomAppBarItem(iconData: Icons.map, text: 'Map'),
              GeopleBottomAppBarItem(iconData: Icons.chat, text: 'Chat'),
              GeopleBottomAppBarItem(iconData: Icons.people, text: 'Friends')
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: (!_textfieldShown)
              ? FloatingActionButton(
                  onPressed: () {
                    key.currentState.updateIndex(0);
                    setState(() {
                      _textfieldShown = true;
                    });
                  },
                  child: Icon(Icons.add_comment),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                )
              : null),
    );
  }

  _sendAndUnfocus(){
    setState(() {
      _isSending = true;
    });
    String textToSend = _textEditingController.text;
    _textEditingController.clear();
    GeopleCloudFunctions cf = GeopleCloudFunctions();
    _getUserLocation().then((position) {
      cf.sendGeoMessage(
          Location(
              latitude: position.latitude,
              longitude: position.longitude),
          textToSend);
      setState(() {
        _isSending = false;
        _textfieldShown = false;
        _canSend = false;
      });
      FocusScope.of(context).unfocus();
    });
  }

  /// TabController sauber löschen.
  @override
  void dispose() {
    super.dispose();
  }

  _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return MapPage();
      case 1:
        return ChatsPage();
      case 2:
        return FriendsPage();
      default:
        return MapPage();
    }
  }

  _buildAppBar() {
    switch (_currentIndex) {
      case 0:
        return null;
      default:
        return AppBar(
          actions: <Widget>[
            MeatballMenuMain(
              context: this.context,
            ),
          ],

          /// Hier wird auf das Attribut des Widgets('widget') zugegriffen.
          title: Text(widget._title),
        );
    }
  }

  bool _safeZoneTop() {
    switch (_currentIndex) {
      case 0:
        return true;
      default:
        return false;
    }
  }

  Future<Position> _getUserLocation() async {
    return _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  _selectedTab(int i) {
    setState(() {
      _currentIndex = i;
    });
  }
}
