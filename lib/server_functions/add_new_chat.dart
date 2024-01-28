import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/databases/chat_database_helper.dart';
import 'package:e_2_e_encrypted_chat_app/databases/message_database_helper.dart';
import 'package:e_2_e_encrypted_chat_app/models/chat_store.dart';
import 'package:sqflite/sqflite.dart';

class AddNewChat {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  ChatDatabaseHelper _chatDb = ChatDatabaseHelper();

  Future<int> addNewChat(ChatStore chatStore) async {
    // await _db
    //     .collection('chats')
    //     .add(chat.toJson())
    //     .then((DocumentReference doc) {
    //   print('DocumentSnapshot added  with ID: ${doc.id}, ${doc.path}');
    //   return db.collection('chats').get();
    // });
    return await _chatDb.insertChat(chatStore);
  }
}
