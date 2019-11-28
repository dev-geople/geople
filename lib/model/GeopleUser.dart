import 'package:intl/intl.dart';

import 'Location.dart';
import 'Model.dart';

class GeopleUser extends Model {
  static const String ATTR_UID = 'uid';
  static const String ATTR_USERNAME = 'username';
  static const String ATTR_TOKEN = 'token';
  static const String ATTR_PROFILE_PICTURE = 'profilePicUrl';
  static const String ATTR_STATUS = 'status';
  static const String ATTR_GEOHASH = 'geohash';
  static const String ATTR_LATITUDE = 'latitude';
  static const String ATTR_LONGITUDE = 'longitude';
  static const String ATTR_LOCATION_TIMESTAMP = 'location_timestamp';

  String uid;
  String username;
  String token;
  String profilePicUrl;
  String status;
  String geohash;
  Location location;
  DateTime locationTime;

  void toObject(Map<String, dynamic> map, {String uid}) {
    this.uid = uid;
    this.username = map['username'];
    this.token = map['token'];
    this.profilePicUrl = map['profilePicUrl'];
    this.status = map['status'];
    this.geohash = map['geohash'];
    this.location = Location(latitude: map['latitude'], longitude: map['longitude']);
    this.locationTime = map['location_timestamp'].toDate();
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return null;
  }
}
