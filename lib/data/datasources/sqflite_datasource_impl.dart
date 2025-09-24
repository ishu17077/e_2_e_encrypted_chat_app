import 'package:chat/chat.dart';
import 'package:e_2_e_encrypted_chat_app/data/constants/table_names.dart';
import 'package:e_2_e_encrypted_chat_app/data/datasources/datasource_contract.dart';
import 'package:e_2_e_encrypted_chat_app/models/chat.dart';
import 'package:e_2_e_encrypted_chat_app/models/local_message.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatasource implements IDataSource {
  final Database _db;
  const SqfliteDatasource(this._db);

  @override
  Future<void> addChat(Chat chat) async {
    await _db.transaction((txn) async {
      await txn.insert(ChatTable.chatsTable, chat.toJSON(),
          conflictAlgorithm: ConflictAlgorithm.rollback);
    });
  }

  @override
  Future<void> addMessage(LocalMessage message) async {
    await _db.transaction((txn) async {
      await txn.insert(MessageTable.messagesTable, message.toJSON(),
          conflictAlgorithm: ConflictAlgorithm.rollback);
    });
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final batch = _db.batch();
    batch.delete(MessageTable.messagesTable,
        where: "chat_id = ?", whereArgs: [chatId]);
    batch.delete(ChatTable.chatsTable, where: "id = ?", whereArgs: [chatId]);

    await batch.commit(noResult: true);
  }

  @override
  Future<List<Chat>> findAllChats() {
    return _db.transaction((txn) async {
      final chatsWithLatestMessage =
          await txn.rawQuery("""SELECT ${MessageTable.messagesTable}.* FROM 
      (SELECT chat_id, 
      MAX(created_at) AS created_at
      FROM ${MessageTable.messagesTable} GROUP BY chat_id
      ) AS latest_messages
      INNER JOIN messages 
      ON ${MessageTable.messagesTable}.${MessageTable.colChatId} = latest_messages.${MessageTable.colChatId}
      AND ${MessageTable.messagesTable}.${MessageTable.colExecutedAt} = latest_messages.${MessageTable.colExecutedAt}
      ORDER BY ${MessageTable.messagesTable}.${MessageTable.colExecutedAt} DESC""");

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

        chat.unread = unread;
        chat.mostRecent = LocalMessage.fromJSON(element);
        return chat;
      }).toList();
    });
  }

  @override
  Future<Chat?> findChat(String chatId) {
    return _db.transaction((txn) async {
      final listOfChatMaps = await txn.query(
        ChatTable.chatsTable,
        where: "${ChatTable.colId} = ?",
        whereArgs: [chatId],
        limit: 1,
      );
      if (listOfChatMaps.isEmpty) {
        return null;
      }
      final unread = Sqflite.firstIntValue(await txn.rawQuery(
          "SELECT COUNT(*) FROM ${MessageTable.messagesTable} WHERE ${MessageTable.colChatId} = ? AND ${MessageTable.colReceipt} = ?",
          [chatId, ReceiptStatus.delivered.value()]));
      final mostRecentMessage = await txn.query(
        MessageTable.messagesTable,
        where: "${MessageTable.colChatId}  = ?",
        orderBy: "${MessageTable.colExecutedAt} DESC",
        limit: 1,
        whereArgs: [chatId],
      );
      final chat = Chat.fromJSON(listOfChatMaps.first);
      chat.unread = unread ?? 0;
      chat.mostRecent = LocalMessage.fromJSON(mostRecentMessage.first);
      return chat;
    });
  }

  @override
  Future<List<LocalMessage>> findMessages(String chatId) {
    return _db.transaction((txn) async {
      final messages = await txn.query(
        MessageTable.messagesTable,
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
    await _db.update(MessageTable.messagesTable, message.toJSON(),
        where: "id = ?", whereArgs: [message.message.id]);
  }

  @override
  Future<void> updateMessageReceipt(
      String messageId, ReceiptStatus status) async {
    await _db.update(MessageTable.messagesTable, {"receipt": status.value()},
        where: "${MessageTable.colId} = ?",
        whereArgs: [messageId],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
