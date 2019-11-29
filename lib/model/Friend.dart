import 'package:geople/model/GeopleUser.dart';

import 'Model.dart';

class Friend extends Model {
  final bool pending;
  final GeopleUser user;

  Friend({this.user, this.pending});

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return null;
  }

  @override
  void toObject(Map<String, dynamic> map) {
    // TODO: implement toObject
  }
}