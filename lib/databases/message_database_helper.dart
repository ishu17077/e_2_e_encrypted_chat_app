import 'package:e_2_e_encrypted_chat_app/models/chat_store.dart';
import 'package:e_2_e_encrypted_chat_app/models/message_store.dart';
import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:sqflite/sqflite.dart';

class MessageDatabaseHelper {
  static MessageDatabaseHelper? _messageDatabaseHelper;
  static Database? _database;

  final String _messagesTable = 'messages_db';
  final String _colId = 'id';
  final String _colrecipientEmail = 'recipient_email';
  final String _colChatId = 'chat_id';
  final String _colTime = 'time';
  final String _colSenderEmail = 'sender_email';
  final String _colContents = 'contents';
  final String _colIsSeen = 'is_seen';

  MessageDatabaseHelper._createInstance();

  factory MessageDatabaseHelper() {
    return _messageDatabaseHelper ?? MessageDatabaseHelper._createInstance();
  }

  Future<Database> get database async {
    return _database ?? await initializeDatabase();
  }

  Future<Database> initializeDatabase() async {
    String path = "${(await directory).path}/databases/messages.db";
    Database messageDatabase =
        await openDatabase(path, onCreate: _createDb, version: 1);
    return messageDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    db.execute(
        'CREATE TABLE $_messagesTable ($_colId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, $_colrecipientEmail TINYTEXT NOT NULL, $_colChatId TEXT NOT NULL, $_colTime VARCHAR(50), $_colSenderEmail TEXT, $_colContents TEXT, $_colIsSeen VARCHAR(5))');
  }

  Future<List<Map<String, dynamic>>> _getMessageMapList(ChatStore chatStore,
      {int? chatId}) async {
    Database db = await database;
    var result = await db.query(_messagesTable,
        where: '$_colChatId = ?',
        whereArgs: [chatStore!.id ?? chatId],
        orderBy: 'time DESC');
    return result;
  }

  Future<int> insertMessage(MessageStore messageStore) async {
    Database db = await database;
    int result = await db.insert(_messagesTable, messageStore.toJson());
    return result;
  }
  //? Future implementation reference for updating or editing a message file
  // Future<int> updateMessage(MessageStore messageStore) async {
  //   Database db = await database;
  //   int result = await db.update(_messagesTable, messageStore.toJson(),
  //       where: '$_colId = ?', whereArgs: [messageStore.id]);
  //   return result;
  // }

  Future<int> deleteMessage(int messageId) async {
    Database db = await database;
    int result = await db
        .delete(_messagesTable, where: '$_colId = ?', whereArgs: [messageId]);
    return result;
  }

  Future<int> getMessagesCount(ChatStore chatStore) async {
    Database db = await database;
    var x = await db.query(_messagesTable,
        where: '$_colChatId = ?', whereArgs: [chatStore.id]);
    int result = Sqflite.firstIntValue(x) ?? 0;
    return result;
  }

  Future<List<MessageStore>> getMessagesList(ChatStore chatStore,
      {int? chatId}) async {
    var messageStoreMapList =
        await _getMessageMapList(chatStore, chatId: chatId);
    List<MessageStore> messageStoreList = List.empty(growable: true);
    for (Map<String, dynamic> messageStoreMap in messageStoreMapList) {
      messageStoreList.add(MessageStore.fromJson(messageStoreMap));
    }
    return messageStoreList;
  }
}
