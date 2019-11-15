import 'package:geople/model/Model.dart';

class Message extends Model{
  static const ME = 'user_of_the_app';

  int id;
  String message;
  String from;
  String to;
  String timestamp;

  Message({
    this.id,
    this.message,
    this.from,
    this.to,
    this.timestamp,
  });


  @override
  void toObject(Map<String, dynamic> map) {
    this.id = id;
    this.message = map['message'];
    this.from = map['message_from'];
    this.to = map['message_to'];
    this.timestamp = map['timestamp'];
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

  @override
  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
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
      Message: $message
      From: $from
      To $to
      Time: $timestamp
      
    ''';
  }
}