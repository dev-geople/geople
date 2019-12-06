import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geople/services/authentication.dart';

class FriendsRepository {
  static const FRIENDLIST_COLLECTION = 'friendslists';

  Future<Map<String, bool>> getFriends() async {
    Map<String, bool> uids = new Map();
    Auth auth = new Auth();
    return auth.getCurrentUser().then((user) {
      return Firestore.instance
          .collection(FRIENDLIST_COLLECTION)
          .document(user.uid)
          .collection('friends')
          .orderBy('pending')
          .getDocuments()
          .then((snapshot) async {
        if (snapshot != null) {
          snapshot.documents.forEach((document) async {
            DocumentReference ref = document.data['reference'];
            bool pending = document.data['pending'];
            uids[ref.documentID] = pending;
          });
          return uids;
        }
        return null;
      });
    });
  }
}
