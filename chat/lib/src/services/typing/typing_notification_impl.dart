import 'dart:async';
import 'package:chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class TypingNotification implements ITypingNotification {
  final FirebaseFirestore _firebaseFirestore;
  final StreamController<TypingEvent> _controller =
      StreamController<TypingEvent>.broadcast();
  late final StreamSubscription? _changeFeed;

  TypingNotification(this._firebaseFirestore);

  @override
  void dispose() {
    _controller.close();
    _changeFeed?.cancel();
  }

  @override
  Future<bool> send(TypingEvent event) async {
    final DocumentReference docRef = await _firebaseFirestore
        .collection("typing_events")
        .add(event.toJSON());
    return docRef.id != null ? true : false;
  }

  @override
  Stream<TypingEvent> subscribe({required User user, List<String>? userIds}) {
    _changeFeed = _firebaseFirestore
        .collection("typing_events")
        .where("from", arrayContains: userIds)
        .where("to", isEqualTo: user.id)
        .snapshots()
        .listen((event) {
          event.docChanges.forEach((element) {
            switch (element.type) {
              case DocumentChangeType.added:
                if (element.doc.data() == null) {
                  return;
                }
                final event = TypingEvent.fromJSON(element.doc.data()!);
                _removingEvent(event);
                _controller.sink.add(event);
              default:
            }
            return;
          });
        });

    _changeFeed?.onError((error) {
      debugPrint(error);
    });
    return _controller.stream;
  }

  _removingEvent(TypingEvent event) {
    _firebaseFirestore.collection("typing_events").doc(event.id).delete();
  }

  TypingEvent _mapIdToTypingEvent(String id, TypingEvent event) {
    return TypingEvent.fromJSON({"id": id, ...event.toJSON()});
  }
}
