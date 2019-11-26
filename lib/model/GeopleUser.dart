import 'Location.dart';
import 'Model.dart';

class GeopleUser extends Model {
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
    //this.locationTime = map['location_timestamp'];
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return null;
  }
}
