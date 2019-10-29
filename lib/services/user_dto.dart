import 'package:cloud_firestore/cloud_firestore.dart';

const USER_COLLECTION = 'user';

class UserDTO {
  Future<DocumentReference> createUser(String uid, String username) {
    //Todo: Save user in database.
    return Firestore.instance.collection(USER_COLLECTION).add({
      'uid': uid,
      'username': username,
    });
  }
}