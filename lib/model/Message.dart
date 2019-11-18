import 'package:geople/model/Model.dart';

class Message extends Model{
  static const ME = 'user_of_the_app';

  int id;
  String message;
  String from;
  String to;
  String timestamp;
  String chatPartner;

  Message({
    this.id,
    this.message,
    this.from,
    this.to,
    this.timestamp,
    this.chatPartner
  });


  @override
  void toObject(Map<String, dynamic> map) {
    this.id = id;
    this.message = map['message'];
    this.from = map['message_from'];
    this.to = map['message_to'];
    this.timestamp = map['timestamp'];
    this.chatPartner = map['chat_partner'];
  }

  static Message fromMap(Map<String, dynamic> map){
    Message message = Message(
      id: map['id'],
      message:  map['message'],
      from:  map['message_from'],
      to: map['message_to'],
      timestamp: map['timestamp'],
    );
    return message;
  }

  static Message fromNotification(Map<String, dynamic> message) {
    var notification = message['notification'];
    var data = message['data'];
    return Message(
      from: data['sender'],
      to: Message.ME,
      message: notification['body'],
      timestamp: DateTime.now().toIso8601String(),
      chatPartner: data['sender'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'chat_partner': this.chatPartner,
      'message': this.message,
      'message_from': this.from,
      'message_to': this.to,
      'timestamp': this.timestamp,
    };
    return map;
  }

  @override
  toString() {
    return '''
    
      ChatPartner: $chatPartner
      Message: $message
      From: $from
      To $to
      Time: $timestamp
      
    ''';
  }
}