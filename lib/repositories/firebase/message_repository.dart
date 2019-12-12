import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geople/model/Message.dart';
import 'package:geople/services/authentication.dart';

class MessageRepository {
  static const CHATS_COLLECTION = 'chats';
  static const CHATLIST_COLLECTION = 'chatlist';
  static const CHATHISTORY_COLLECTION = 'chat-history';

  Future<List<Message>> getChatList() {
    List<Message> messages = List<Message>();
    Auth auth = new Auth();
    return auth.getCurrentUser().then((user) {
      return Firestore.instance
          .collection(CHATS_COLLECTION)
          .document(user.uid)
          .collection(CHATLIST_COLLECTION)
          .getDocuments()
          .then((snapshot) {
        print(snapshot.documents.length);
        for (DocumentSnapshot ds in snapshot.documents) {
          var lastMessageData =
              new Map<String, dynamic>.from(ds.data['last_message']);

          print("DS DATA " + lastMessageData.toString());
          Message msg = Message.fromMap(lastMessageData);
          messages.add(msg);
        }
        print(messages.toString());
        return messages;
      });
    });
  }

  Future<void> deleteChat(String uid) async {
    Auth auth = new Auth();
    return auth.getCurrentUser().then((user) {
      return Firestore.instance
          .collection(CHATS_COLLECTION)
          .document(user.uid)
          .collection(CHATLIST_COLLECTION)
          .document(uid)
          .delete();
    });
  }
}
