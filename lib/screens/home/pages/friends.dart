import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FriendsPageState();
  }
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
          child: Icon(Icons.people_outline),
    );
  }
}
