import 'dart:async';
import 'package:chat/src/models/message.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/encryption/encryption_contract.dart';
import 'package:chat/src/services/message/message_service_contract.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MessageService implements IMessageService {
  final FirebaseFirestore _firestore;
  final IEncryption _encryption;
  final StreamController<Message> _controller =
      StreamController<Message>.broadcast();
  StreamSubscription? _changeFeed;

  MessageService(this._firestore, {required IEncryption encryption})
    : _encryption = encryption;

  @override
  void dispose() {
    _changeFeed?.cancel();
    _controller.close();
  }

  @override
  Stream<Message> messages({required User activeUser}) {
    _startRecievingMessages(activeUser);
    return _controller.stream;
  }

  @override
  Future<Message> send(Message message) async {
    late final Message messageReturn;
    message.contents = _encryption.encrypt(message.contents);
    DocumentReference<Map<String, dynamic>> docRef = await _firestore
        .collection("messages")
        .add(message.toJSON());
    messageReturn = _mapIdToMessage(docRef.id, message);
    return messageReturn;
  }

  void _startRecievingMessages(User user) {
    _changeFeed = _firestore
        .collection("messages")
        .where("to", isEqualTo: user.id)
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
          snapshot.docChanges.forEach((element) {
            switch (element.type) {
              case DocumentChangeType.added:
                if (element.doc.data() == null) {
                  return;
                }
                final Message message = _messageFromFeed(element.doc.data()!);
                _controller.sink.add(message);
                _removeDelieveredMessage(message);
              default:
            }
            return;
          });
        });

    _changeFeed?.onError((error) {
      debugPrint(error);
    });
  }

  Message _messageFromFeed(Map<String, dynamic> messageMap) {
    messageMap["contents"] = _encryption.decrypt((messageMap["contents"]));

    final Message message = Message.fromJSON(messageMap);
    return message;
  }

  void _removeDelieveredMessage(Message message) {
    _firestore.collection("messages").doc(message.id).delete();
  }

  Message _mapIdToMessage(String id, Message message) {
    return Message.fromJSON({"id": id, ...(message.toJSON())});
  }
}
