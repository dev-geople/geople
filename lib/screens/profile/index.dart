import 'package:flutter/material.dart';
import 'package:geople/model/GeopleUser.dart';
import 'package:geople/screens/profile/widgets/profile_actions.dart';
import 'package:geople/screens/profile/widgets/profile_header.dart';
import 'package:geople/services/user_dto.dart';


class ProfileScreen extends StatefulWidget {
  ProfileScreen({this.uid});

  final String uid;

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  GeopleUser _user;

  @override
  void initState() {
    UserDTO _dto = UserDTO();
    _dto.getUserDetails(widget.uid).then((snapshot) {
      if (snapshot.data != null) {
        GeopleUser user = GeopleUser();
        user.toObject(snapshot.data);
        user.uid = widget.uid;
        setState(() {
          _user = user;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_user != null)
      return SafeArea(
        top: false,
        child: Scaffold(
            appBar: AppBar(
              title: Text(_user.username ?? 'Profile'),
            ),
            body: Column(
              children: <Widget>[
                ProfileHeader(user: _user),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: ProfileActions(user: _user),
                    ),
                  ],
                )
              ],
            )
        ),
      );
    return Text('');
  }
}
