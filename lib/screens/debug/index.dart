import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geople/model/GeopleUser.dart';
import 'package:geople/services/user_dto.dart';
import 'package:geople/widgets/user_tile.dart';

class DebugScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
            stream: Firestore.instance.collection(UserDTO.USER_COLLECTION).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return new Text('Loading...');
              return new ListView(
                children: snapshot.data.documents.map((document) {
                  GeopleUser user = GeopleUser();
                  user.toObject(document.data, uid: document.documentID);
                  return UserTile(user: user);
                }).toList(),
              );
            },
          )
      );
  }
}