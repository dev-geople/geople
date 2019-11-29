import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geople/model/GeopleUser.dart';
import 'package:geople/router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapHelper {
  static createMarkersFromHttpsResult(HttpsCallableResult result, BuildContext context) {
    Set<Marker> _markers = new Set();
    List<dynamic> resultData = result.data;
    resultData.forEach((element){
      if(element != null){
        var userData = element['data'];
        _markers.add(Marker(
          markerId: MarkerId(element[GeopleUser.ATTR_UID]),
          position: LatLng(
            userData['location']['_latitude'],
            userData['location']['_longitude']
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(190.0),
          infoWindow: InfoWindow(
            title: userData[GeopleUser.ATTR_USERNAME],
            snippet: userData[GeopleUser.ATTR_STATUS],
            onTap: () => Navigator.of(context).pushNamed(
                Routes.PROFILE,
                arguments: element[GeopleUser.ATTR_UID]
            )
          )
        ));
      }
    });
    return _markers;
  }

  static Future<bool> checkWithinMeters(Position pos1, Position pos2, int distance, Geolocator geolocator) async {
    await geolocator.distanceBetween(
        pos1.latitude, pos1.longitude,
        pos2.latitude, pos2.longitude
    ).then((val) {
      return val > distance;
    });
  }
}