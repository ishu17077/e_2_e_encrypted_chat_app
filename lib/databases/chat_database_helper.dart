import 'dart:io';
import 'package:e_2_e_encrypted_chat_app/models/chat_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class ChatDatabaseHelper {
  static ChatDatabaseHelper? _chatDatabaseHelper;
  static Database? _database;

  String chatTable = 'chat_db';
  String colId = 'id';
  String colBelongsToEmail = 'belongs_to_email';
  String colPhotoUrl = 'photo_url';
  String colChatId = 'chat_id';

  ChatDatabaseHelper._createInstance();

  factory ChatDatabaseHelper() {
    return _chatDatabaseHelper ?? ChatDatabaseHelper._createInstance();
  }

  Future<Database> get database async {
    return _database ?? await initializeDatabase();
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = "${directory.path}/databases/chats.db";
    var chatsDatabase =
        await openDatabase(path, onCreate: _createDb, version: 1);
    return chatsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $chatTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colBelongsToEmail TINYTEXT, $colPhotoUrl TEXT, $colChatId TEXT NOT NULL)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getChatMapList() async {
    Database db = await database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(chatTable);
    return result;
  }

  Future<int> insertChat(ChatStore chatStore) async {
    Database db = await database;
    int result = await db.insert(chatTable, chatStore.toJson());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  // Future<int> updateNote(Note note) async {
  // 	var db = await this.database;
  // 	var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
  // 	return result;
  // }

  Future<int> deleteChat(ChatStore chatStore) async {
    Database db = await database;
    int result = await db
        .delete(chatTable, where: '$colId = ?', whereArgs: [chatStore.id]);
    return result;
  }

  Future<int> getChatsCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.query('SELECT COUNT (*) FROM $chatTable');
    int result = Sqflite.firstIntValue(x) ?? 0;
    return result;
  }
}	// Update Operation: Update a Note object and save it to database
	Future<int> updateNote(Note note) async {
		var db = await this.database;
		var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
		return result;
	}
