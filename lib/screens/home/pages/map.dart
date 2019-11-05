import 'package:flutter/material.dart';
import 'package:geople/app_localizations.dart';
import 'package:geople/services/geople_cloud_functions.dart';

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapPageState();
  }
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.map),
        Text(AppLocalizations.of(context).translate('helloWorld')),
        RaisedButton(onPressed: () {
          //TODO: Freundesanfrage auslagern
        GeopleCloudFunctions().sendFriendRequest('dahjalslsalsad')
            .then((result) {
              print(result?.data['message']);
            });
        }),
      ],
    );
  }
}
