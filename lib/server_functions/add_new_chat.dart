import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_2_e_encrypted_chat_app/models/chat.dart';

class AddNewChat {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future addNewChat(Chat chat) async {
    await db
        .collection('chats')
        .add(chat.toJson())
        .then((DocumentReference doc) {
      print('Lolskdjkdj DocumentSnapshot added  with ID: ${doc.id}, ${doc.path}');
      return db.collection('chats').get();
    });
  }
}
