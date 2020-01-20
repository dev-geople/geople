import 'package:flutter/material.dart';
import 'package:geople/model/GeopleUser.dart';
import 'package:geople/screens/chat/arguments.dart';
import 'package:geople/services/authentication.dart';
import 'package:geople/services/geople_cloud_functions.dart';
import 'package:geople/widgets/rounded_buttons.dart';

import '../../../router.dart';

class ProfileActions extends StatefulWidget {
  ProfileActions({this.user});

  final GeopleUser user;

  @override
  State<StatefulWidget> createState() => _ProfileActionsState();
}

class _ProfileActionsState extends State<ProfileActions> {
  bool _isSendingFriendRequest = false;
  bool _friendRequestSent = false;
  bool _isMe = false;
  bool _isLoading = true;

  @override
  void initState() {
    Auth auth = Auth();
    auth.getCurrentUser().then((user) {
      setState(() {
        _isMe = user.uid == widget.user.uid;
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_isMe) {
      return buildSelfActions();
    } else
      return buildOtherActions();
  }

  /// Eigenes Profil.
  Widget buildSelfActions() {
    return Column(
      children: <Widget>[
        RoundedButtonPrimary(
          translatorKey: 'change_password',
        )
      ],
    );
  }

  /// Profil einer anderen Person.
  Widget buildOtherActions() {
    return Row(
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
                  child: Text(_friendRequestSent ? 'PENDING' : 'ADD FRIEND'),
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainSemantics: true,
                  maintainState: true,
                  maintainInteractivity: false,
                  visible: !_isSendingFriendRequest,
                ),
                Visibility(
                  child: Center(
                    child: SizedBox(
                      height: 28,
                      width: 28,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  visible: this._isSendingFriendRequest,
                ),
              ],
            ),
            onPressed: this._isSendingFriendRequest || this._friendRequestSent
                ? null
                : () {
                    setState(() {
                      this._isSendingFriendRequest = true;
                    });
                    GeopleCloudFunctions()
                        .sendFriendRequest(widget.user.uid)
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
        )),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 7.5, right: 15),
            child: RaisedButton(
              child: Text("START CHAT"),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.CHAT,
                    arguments: ChatScreenArguments(
                        uid: widget.user.uid, deleteChat: false));
              },
            ),
          ),
        ),
      ],
    );
  }
}
