import 'package:chat/chat.dart';
import 'package:secuchat/data/constants/table_names.dart';
import 'package:secuchat/data/datasources/datasource_contract.dart';
import 'package:secuchat/models/chat.dart';
import 'package:secuchat/models/local_message.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatasource implements IDataSource {
  final Database _db;
  const SqfliteDatasource(this._db);

  @override
  Future<void> addChat(Chat chat) async {
    await _db.transaction((txn) async {
      await txn.insert(ChatTable.tableName, chat.toJSON(),
          conflictAlgorithm: ConflictAlgorithm.rollback);
    });
  }

  @override
  Future<void> addMessage(LocalMessage message) async {
    await _db.transaction((txn) async {
      await txn.insert(MessageTable.tableName, message.toJSON(),
          conflictAlgorithm: ConflictAlgorithm.rollback);
    });
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final batch = _db.batch();
    batch.delete(MessageTable.tableName,
        where: "${MessageTable.colChatId} = ?", whereArgs: [chatId]);
    batch.delete(ChatTable.tableName, where: "id = ?", whereArgs: [chatId]);

    await batch.commit(noResult: true);
  }

  @override
  Future<List<Chat>> findAllChats() {
    return _db.transaction((txn) async {
      final chatsWithLatestMessage =
          await txn.rawQuery("""SELECT ${MessageTable.tableName}.* FROM 
      (SELECT chat_id, 
      MAX(created_at) AS created_at
      FROM ${MessageTable.tableName} GROUP BY chat_id
      ) AS latest_messages
      INNER JOIN ${MessageTable.tableName} 
      ON ${MessageTable.tableName}.${MessageTable.colChatId} = latest_messages.${MessageTable.colChatId}
      AND ${MessageTable.tableName}.${MessageTable.colExecutedAt} = latest_messages.${MessageTable.colExecutedAt}
      INNER JOIN ${ChatTable.tableName}
      ON ${ChatTable.tableName}.${ChatTable.colId} = latest_messages.${MessageTable.tableName}.${MessageTable.colChatId}  
      INNER JOIN ${UserTable.tableName}
      ON ${UserTable.tableName}.${UserTable.colId} = ${ChatTable.tableName}.${ChatTable.colUserId}
      ORDER BY ${MessageTable.tableName}.${MessageTable.colExecutedAt} DESC""");

      if (chatsWithLatestMessage.isEmpty) {
        return [];
      }

      final chatsWithUnreadMessages =
          await txn.rawQuery("""SELECT chat_id, COUNT(*) 
      as unread FROM messages
      WHERE receipt = ?
      GROUP BY chat_id""", ["delivered"]);

      return chatsWithLatestMessage.map((element) {
        final int unread = chatsWithUnreadMessages.firstWhere(
          (ele) => element["chat_id"] == ele["chat_id"],
          orElse: () => {"unread": 0},
        )["unread"] as int;

        final Chat chat = Chat.fromJSON(element);
        final User user = User.fromJSON(element);
        chat.unread = unread;
        chat.from = user;
        chat.mostRecent = LocalMessage.fromJSON(element);
        return chat;
      }).toList();
    });
  }

  @override
  Future<Chat?> findChat({String? chatId, String? userId}) {
    assert(chatId != null || userId != null,
        "Either chatId of userId must be present");
    return _db.transaction((txn) async {
      final selectedId = chatId ?? userId;
      final selectedIdColumn =
          chatId != null ? ChatTable.colId : ChatTable.colUserId;
      final listOfChatMaps = await txn.query(
        ChatTable.tableName,
        where: "$selectedIdColumn = ?",
        whereArgs: [selectedId],
        limit: 1,
      );
      if (listOfChatMaps.isEmpty) {
        return null;
      }
      final unread = Sqflite.firstIntValue(await txn.rawQuery(
        "SELECT COUNT(*) FROM ${MessageTable.tableName} WHERE ${MessageTable.colChatId} = ? AND ${MessageTable.colReceipt} = ?",
        [chatId, ReceiptStatus.delivered.value()],
      ));
      final mostRecentMessage = await txn.query(
        MessageTable.tableName,
        where: "${MessageTable.colChatId}  = ?",
        orderBy: "${MessageTable.colExecutedAt} DESC",
        limit: 1,
        whereArgs: [chatId],
      );
      final chat = Chat.fromJSON(listOfChatMaps.first);
      final userMap = (await txn.query(
        UserTable.tableName,
        where: "user_id = ?",
        whereArgs: [listOfChatMaps.first["user_id"]],
        limit: 1,
      ))
          .first;

      User user = User.fromJSON(userMap);
      chat.from = user;
      chat.unread = unread ?? 0;
      chat.mostRecent = LocalMessage.fromJSON(mostRecentMessage.first);
      return chat;
    });
  }

  @override
  Future<List<LocalMessage>> findMessages(String chatId) {
    return _db.transaction((txn) async {
      final messages = await txn.query(
        MessageTable.tableName,
        where: "${MessageTable.colChatId} = ?",
        orderBy: "${MessageTable.colExecutedAt} DESC",
        whereArgs: [chatId],
      );

      return messages
          .map((messageMap) => LocalMessage.fromJSON(messageMap))
          .toList();
    });
  }

  @override
  Future<void> updateMessage(LocalMessage message) async {
    await _db.update(MessageTable.tableName, message.toJSON(),
        where: "id = ?", whereArgs: [message.message.id]);
  }

  @override
  Future<void> updateMessageReceipt(
      String messageId, ReceiptStatus status) async {
    await _db.update(MessageTable.tableName, {"receipt": status.value()},
        where: "${MessageTable.colId} = ?",
        whereArgs: [messageId],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> addUser(User user) async {
    await _db.transaction((txn) async {
      //! ERROR PRONE due to extra columns, if that happens, please rectify broooooo!
      await txn.insert(UserTable.tableName, user.toJSON(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _db.delete(
      UserTable.tableName,
      where: "${UserTable.colId} = ?",
      whereArgs: [userId],
    );
  }

  @override
  Future<void> updateUser(User user) async {
    await _db.update(UserTable.tableName, user.toJSON(),
        where: "${UserTable.colId} = ?", whereArgs: [user.id]);
  }
}
