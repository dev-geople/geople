import 'package:geople/model/Message.dart';
import 'package:sqflite/sqflite.dart';

class MessageRepository {
  final fileName = 'messages.db';

  static const String TABLE_MESSAGES = 'messages';
  static const String COLUMN_ID = 'message_id';
  static const String COLUMN_MESSAGE = 'message';
  static const String COLUMN_FROM = 'message_from';
  static const String COLUMN_TO = 'message_to';
  static const String COLUMN_TIMESTAMP = 'timestamp';
  static const String COLUMN_CHAT_PARTNER = 'chat_partner';

  Database db;
  String path;

  MessageRepository() {
    this.initilizeDB();
  }

  Future<void> initilizeDB() async {
    var databasesPath = await getDatabasesPath();
    this.path = databasesPath + this.fileName;
    this.db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE $TABLE_MESSAGES (
            $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $COLUMN_FROM TEXT NOT NULL,
            $COLUMN_TO TEXT NOT NULL,
            $COLUMN_MESSAGE TEXT NOT NULL,
            $COLUMN_TIMESTAMP TEXT NOT NULL,
            $COLUMN_CHAT_PARTNER TEXT NOT NULL
          )
          ''');
    });
  }

  Future<Message> saveMessage(Message message) async {
    if (db != null) {
      await db.insert(TABLE_MESSAGES, message.toMap());
      print('MESSAGE SAVED: $message.$toString()');
      return message;
    } else {
      await initilizeDB();
      saveMessage(message);
    }
    return message;
  }

  Future<Message> saveMessageFromNotification(
      Map<String, dynamic> message) async {
    Message msgToSave = Message.fromNotification(message);
    await saveMessage(msgToSave);
    return msgToSave;
  }

  Future<List<Message>> getMessagesOfUser(String uid) async {
    List<Message> messages = new List<Message>();
    if (db == null) await this.initilizeDB();
    List<Map> maps = await db.query(
      TABLE_MESSAGES,
      columns: [
        COLUMN_CHAT_PARTNER,
        COLUMN_FROM,
        COLUMN_MESSAGE,
        COLUMN_TIMESTAMP,
        COLUMN_TO
      ],
      where: '$COLUMN_FROM = ? OR $COLUMN_TO = ?',
      whereArgs: [uid, uid],
    );
    if (maps.length > 0) {
      maps.forEach((e) {
        messages.add(Message.fromMap(e));
      });
      return messages;
    }
    return null;
  }

  Future<List<Message>> getChatList() async {
    List<Message> messages = new List<Message>();
    if (db == null) await this.initilizeDB();
    List<Map> maps = await db.query(TABLE_MESSAGES,
        columns: [
          COLUMN_CHAT_PARTNER,
          COLUMN_FROM,
          COLUMN_MESSAGE,
          COLUMN_TIMESTAMP,
          COLUMN_TO
        ],
        orderBy: COLUMN_TIMESTAMP + ' DESC',
        groupBy: COLUMN_CHAT_PARTNER);
    bool add = true;
    if (maps.length > 0) {
      maps.forEach((e) {
        add = true;
        messages.forEach((ee) {
          if (ee.chatPartner == e[COLUMN_CHAT_PARTNER]) {
            add = false;
          }
        });
        if (add) messages.add(Message.fromMap(e));
      });
      return messages;
    }
    return null;
  }

  Future<int> deleteMessagesOfUser(String uid) async {
    if (db == null) await this.initilizeDB();

    return await db.delete(
      TABLE_MESSAGES,
      where: '$COLUMN_CHAT_PARTNER = ?',
      whereArgs: [uid],
    );
  }

  Future<bool> printMessages(String uid) async {
    List<Message> messages = new List<Message>();
    List<Map> maps = await db.query(
      TABLE_MESSAGES,
      columns: [
        COLUMN_CHAT_PARTNER,
        COLUMN_FROM,
        COLUMN_MESSAGE,
        COLUMN_TIMESTAMP,
        COLUMN_TO
      ],
      where: '$COLUMN_FROM = ? or $COLUMN_TO = ?',
      whereArgs: [uid, uid],
    );
    if (maps.length > 0) {
      maps.forEach((e) {
        messages.add(Message.fromMap(e));
      });
    }
    return true;
  }
}
