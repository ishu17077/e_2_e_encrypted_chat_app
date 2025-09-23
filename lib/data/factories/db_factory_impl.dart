import 'package:e_2_e_encrypted_chat_app/data/constants/table_names.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseFactory {
  //TODO: Future implementation, of how to delete message after being sent
  // static const String _colMessageIdFromServer = 'message_id_from_server';
  static LocalDatabaseFactory? _localDatabaseFactory;

  LocalDatabaseFactory._createInstance();

  factory LocalDatabaseFactory() {
    _localDatabaseFactory =
        _localDatabaseFactory ?? LocalDatabaseFactory._createInstance();
    return _localDatabaseFactory!;
  }

  Database? _database;

  Future<Database> createDatabase() async {
    if (_database != null) {
      return _database!;
    }
    String databasePath = await getDatabasesPath();
    String dbPath = join(databasePath, "secuchat.db");
    _database = await openDatabase(dbPath, onCreate: populateDb, version: 1);
    return _database!;
  }

  Future<void> populateDb(Database db, int version) async {
    await _createChatTable(db);
    await _createMessageTable(db);
  }

  Future<void> _createChatTable(Database db) async {
    await db.execute("""CREATE TABLE ${ChatTable.chatsTable} (
        ${ChatTable.colId} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        ${ChatTable.colName} VARCHAR(100),
        ${ChatTable.colEmail} VARCHAR(255) NOT NULL, 
        ${ChatTable.colPhotoUrl} TEXT, 
        ${ChatTable.colUsername} TINYTEXT,
        ${ChatTable.colUserIdFromServer} VARCHAR(50) NOT NULL,
        ${ChatTable.colCreatedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL""").then((_) {
      debugPrint("Successfully created ${ChatTable.chatsTable} Table");
    }).catchError((e) {
      debugPrint(" ${ChatTable.chatsTable} table creation failed: $e");
    });
  }

  Future<void> _createMessageTable(Database db) async {
    await db.execute("""CREATE TABLE ${MessageTable.messagesTable}(
    ${MessageTable.colId} INTEGER PRIMARY KEY NOT NULL AUTOINCREMENT,
    ${MessageTable.colChatId} TEXT NOT NULL,
    ${MessageTable.colSender} TEXT NOT NULL,
    ${MessageTable.colRecipient} TEXT NOT NULL,
    ${MessageTable.colReceipt} TEXT NOT NULL,
    ${MessageTable.colContents} TEXT NOT NULL,
    ${MessageTable.colCreatedAt} TIMESTAMP DEFAULT CUTRRENT_TIMESTAMP NOT NULL,
    ${MessageTable.colExecutedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
    )""").then((_) {
      debugPrint("Successfully created ${MessageTable.messagesTable} table");
    }).catchError((e) {
      debugPrint("${MessageTable.messagesTable} table creation failed");
    });
  }
}
