import 'package:flutter/material.dart';
import 'package:geople/model/GeopleUser.dart';
import 'package:geople/repositories/firebase/user_repository.dart';
import 'package:geople/services/authentication.dart';
import 'package:geople/widgets/profile_picture.dart';

class ProfileHeader extends StatefulWidget {
  ProfileHeader({this.user});

  final GeopleUser user;

  @override
  State<StatefulWidget> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  bool _isMe = false;
  String _status = '';
  TextEditingController _statusController = TextEditingController();

  @override
  void initState() {
    Auth auth = Auth();
    auth.getCurrentUser().then((user) {
      setState(() {
        _isMe = user.uid == widget.user.uid;
        _status = widget.user.status;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 5,
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 25, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ProfilePictureMedium(
                        imageUrl:
                            'https://lakewangaryschool.sa.edu.au/wp-content/uploads/2017/11/placeholder-profile-sq.jpg'),
                    //Todo: ProfilePic
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.user.username ?? '',
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.title.fontSize,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _status ?? 'Status',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    (_isMe)
                        ? IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            splashColor: Theme.of(context).accentColor,
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) => AlertDialog(
                                  content: TextField(
                                    maxLength: 30,
                                    maxLengthEnforced: true,
                                    autofocus: true,
                                    controller: _statusController,
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('CANCEL'), //Todo: translate
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("SET"), //Todo: translate
                                      onPressed: () {
                                        UserDTO repo = UserDTO();
                                        Auth auth = Auth();
                                        if(_statusController.text.length > 0) {
                                          auth.getCurrentUser().then((user) {
                                            repo.setStatus(user.uid, _statusController.text).then((newStatus){
                                              setState(() {
                                                _status = newStatus;
                                              });
                                              Navigator.of(context).pop();
                                            });
                                          });
                                        }
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        : Center()
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
