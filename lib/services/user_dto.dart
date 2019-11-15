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

}
