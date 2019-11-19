import 'package:flutter/material.dart';
import 'package:geople/model/GeopleUser.dart';
import 'package:geople/widgets/profile_picture.dart';

class ProfileHeader extends StatelessWidget {
  ProfileHeader({this.user});
  final GeopleUser user;

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
                    ProfilePictureMedium(imageUrl: 'https://lakewangaryschool.sa.edu.au/wp-content/uploads/2017/11/placeholder-profile-sq.jpg'),  //Todo; ProfilePic
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(user.username ?? '',
                      style: Theme.of(context).textTheme.title),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(user.status ?? 'Status'),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}