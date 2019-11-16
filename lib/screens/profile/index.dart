import 'package:flutter/material.dart';
import 'package:geople/model/GeopleUser.dart';
import 'package:geople/screens/profile/widgets/profile_header.dart';
import 'package:geople/services/geople_cloud_functions.dart';
import 'package:geople/services/user_dto.dart';

import '../../router.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({this.uid});

  final String uid;

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  GeopleUser _user = GeopleUser();
  bool _isSendingFriendRequest = false;
  bool _friendRequestSent = false;

  @override
  void initState() {
    UserDTO _dto = UserDTO();
    _dto.getUserDetails(widget.uid).then((snapshot) {
      if (snapshot.data != null) {
        GeopleUser user = GeopleUser();
        user.toObject(snapshot.data);
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 15, right: 7.5),
                                child: OutlineButton(
                                  child: Stack(
                                    children: <Widget>[
                                      Visibility(
                                        child: Text(
                                            _friendRequestSent ? 'PENDING' : 'ADD FRIEND'
                                        ),
                                        maintainSize: true,
                                        maintainAnimation: true,
                                        maintainSemantics: true,
                                        maintainState: true,
                                        maintainInteractivity: false,
                                        visible: !this._isSendingFriendRequest,
                                      ),
                                      Visibility(
                                        child: Center(
                                          child: SizedBox(
                                            height: 28,
                                            width: 28,
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                            ),
                                          ),
                                        ),
                                        visible: this._isSendingFriendRequest,
                                      ),
                                    ],
                                  ),
                                  onPressed: this._isSendingFriendRequest ||
                                      this._friendRequestSent ? null : () {
                                    setState(() {
                                      this._isSendingFriendRequest = true;
                                    });
                                    GeopleCloudFunctions().sendFriendRequest(widget.uid)
                                        .then((result) {
                                      if (result.data != null) {
                                        setState(() {
                                          this._friendRequestSent = true;
                                          this._isSendingFriendRequest = false;
                                        });
                                      } else {
                                        print(result.toString());
                                      }
                                    });
                                  },
                                ),
                              )
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 7.5, right: 15),
                              child: RaisedButton(
                                child: Text("START CHAT"),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(Routes.CHAT, arguments: widget.uid);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )
        ),
      );
  }
}
