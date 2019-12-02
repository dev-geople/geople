import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geople/model/GeopleUser.dart';

class UserDTO {
  static const USER_COLLECTION = 'user';

  Future<void> createUser(String uid, String username, String token) {
    Map<String, dynamic> user = {
      'username': username,
      'token': token,
      'status': 'Hello I\'m a Geople',
    };

    DocumentReference userDocument = Firestore.instance.document(USER_COLLECTION + "/" + uid );

    return userDocument.setData(user);
  }

  Future<void> saveToken(String uid, String token) {
    return Firestore.instance.collection(USER_COLLECTION).document(uid)
        .updateData({
      'token': token,
    });
  }

  Future<DocumentSnapshot> getUserDetails(String uid) {
    return Firestore.instance.collection(USER_COLLECTION).document(uid).get();
  }

  Future<GeopleUser> getGeopleUser(String uid) async{
    return this.getUserDetails(uid).then((snapshot) {
      GeopleUser user = GeopleUser();
      var data = snapshot.data;
      if(data.containsKey('username')) user.username = data['username'];
      if(data.containsKey('profilePicUrl')) user.profilePicUrl = data['profilePicUrl'];
      if(data.containsKey('token')) user.token = data['token'];
      if(data.containsKey('status')) user.status = data['status'];

      return user;
    });
  }

  Future<String> setStatus(String uid, String status) async {
    await Firestore.instance.collection(USER_COLLECTION).document(uid)
        .updateData({
      'status': status,
    });
    return status;
  }

}
