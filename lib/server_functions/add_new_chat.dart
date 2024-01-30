import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/databases/chat_database_helper.dart';
import 'package:e_2_e_encrypted_chat_app/databases/message_database_helper.dart';
import 'package:e_2_e_encrypted_chat_app/models/chat_store.dart';
import 'package:sqflite/sqflite.dart';

class AddNewChat {
  final ChatDatabaseHelper _chatDb = ChatDatabaseHelper();

  Future<int> addNewChat(ChatStore chatStore) async {
    return await _chatDb.insertChat(chatStore);
  }
}
