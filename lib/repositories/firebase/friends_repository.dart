import 'package:geople/model/GeopleUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geople/services/authentication.dart';
import 'package:geople/services/user_dto.dart';

class FriendsRepository {
  static const FRIENDLIST_COLLECTION = 'friendslists';

  Future<List<String>> getFriends() async{
    List<String> references = new List();
    Auth auth = new Auth();
    return auth.getCurrentUser().then((user){
        return Firestore.instance.collection(FRIENDLIST_COLLECTION).document(user.uid).collection('friends').getDocuments()
          .then((snapshot) async{
            if(snapshot != null) {
              snapshot.documents.forEach((document) async{
                DocumentReference ref = document.data['reference'];
                bool pending = document.data['pending'];
                references.add(ref.documentID);
              });
              return references;
            }
            return null;
      });
    });
  }
}