import 'package:chat/src/models/receipt.dart';
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
  Future<Chat> findChat(String chatId) {
    // TODO: implement findChat
    throw UnimplementedError();
  }

  @override
  Future<List<LocalMessage>> findMessages(String chatId) {
    // TODO: implement findMessages
    throw UnimplementedError();
  }

  @override
  Future<void> updateMessage() {
    // TODO: implement updateMessage
    throw UnimplementedError();
  }

  @override
  Future<void> updateMessageReceipt(String messageId, ReceiptStatus status) {
    // TODO: implement updateMessageReceipt
    throw UnimplementedError();
  }
}
