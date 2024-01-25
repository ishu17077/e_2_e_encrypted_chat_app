import 'package:e_2_e_encrypted_chat_app/models/chat_store.dart';
import 'package:e_2_e_encrypted_chat_app/unit_components.dart';
import 'package:sqflite/sqflite.dart';

class ChatDatabaseHelper {
  static ChatDatabaseHelper? _chatDatabaseHelper;
  static Database? _database;

  final String _chatTable = 'chats_db';
  final String _colId = 'id';
  final String _colBelongsToEmail = 'belongs_to_email';
  final String _colPhotoUrl = 'photo_url';
  final String _colName = 'name';

  ChatDatabaseHelper._createInstance();

  factory ChatDatabaseHelper() {
    return _chatDatabaseHelper ?? ChatDatabaseHelper._createInstance();
  }

  Future<Database> get database async {
    return _database ?? await initializeDatabase();
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.

    String path = "${(await directory).path}/databases/chats.db";
    var chatsDatabase =
        await openDatabase(path, onCreate: _createDb, version: 1);
    return chatsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $_chatTable ($_colId INTEGER PRIMARY KEY AUTOINCREMENT, $_colBelongsToEmail TINYTEXT, $_colPhotoUrl TEXT, $_colName VARCHAR(50))');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> _getChatMapList() async {
    Database db = await database;
//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(_chatTable); //? We have to do a left join here
    return result;
  }

  Future<int> insertChat(ChatStore chatStore) async {
    Database db = await database;
    int result = await db.insert(_chatTable, chatStore.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
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
        .delete(_chatTable, where: '$_colId = ?', whereArgs: [chatStore.id]);
    return result;
  }

  Future<int> getChatsCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.query('SELECT COUNT (*) FROM $_chatTable');
    int result = Sqflite.firstIntValue(x) ?? 0;
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateChat(ChatStore chatStore) async {
    var db = await database;
    var result = await db.update(_chatTable, chatStore.toJson(),
        where: '$_colId = ?',
        whereArgs: [chatStore.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<List<ChatStore>> getChatsList() async {
    var chatMapList = await _getChatMapList();
    print(chatMapList);
    List<ChatStore> chatStoreList = List.empty(growable: true);
    for (Map<String, dynamic> chatMap in chatMapList) {
      chatStoreList.add(ChatStore.fromJson(chatMap));
    }
    return chatStoreList;
  }
}