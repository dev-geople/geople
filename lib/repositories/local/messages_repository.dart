import 'package:geople/model/Message.dart';
import 'package:sqflite/sqflite.dart';

class MessageRepository {
  final fileName = 'messages.db';

  final String tableMessages = 'messages';
  final String columnId = 'message_id';
  final String columnMessage = 'message';
  final String columnFrom = 'message_from';
  final String columnTo = 'message_to';
  final String columnTimestamp = 'timestamp';

  Database db;
  String path;

  MessageRepository() {
    this.initilizeDB();
  }

  Future<void> initilizeDB() async {
    var databasesPath = await getDatabasesPath();
    this.path = databasesPath + this.fileName; //Todo: möglicherweise Fehler (/)
    this.db = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
          CREATE TABLE $tableMessages (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnFrom TEXT NOT NULL,
            $columnTo TEXT NOT NULL,
            $columnMessage TEXT NOT NULL,
            $columnTimestamp TEXT NOT NULL
          )
          '''
        );
      }
    );
  }

  Future<Message> saveMessage(Message message) async {
    await db.insert(this.tableMessages, message.toMap());
    print('MESSAGE SAVED: $message.$toString()');
    return message;
  }

  Future<List<Message>> getMessagesOfUser(String uid) async {
    List<Message> messages = new List<Message>();
    if(db == null) await this.initilizeDB();
    List<Map> maps = await db.query(this.tableMessages,
      columns: [columnMessage, columnFrom, columnTo, columnTimestamp],
      where: '$columnFrom = ? OR $columnTo = ?',
      whereArgs: [uid, uid],
    );
    if(maps.length > 0) {
      maps.forEach((e){
        messages.add(Message.fromMap(e));
      });
      return messages;
    }
    return null;
  }

  Future<bool> printMessages(String uid) async {
    List<Message> messages = new List<Message>();
    List<Map> maps = await db.query(this.tableMessages,
      columns: [columnMessage, columnFrom, columnTo, columnTimestamp],
      where: '$columnFrom = ? or $columnTo = ?',
      whereArgs: [uid, uid],
    );
    if(maps.length > 0) {
      maps.forEach((e){
        messages.add(Message.fromMap(e));
      });
    }
    return true;
  }
}