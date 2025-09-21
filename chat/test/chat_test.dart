import 'package:chat/chat.dart';
import 'package:chat/src/services/encryption/encryption_contract.dart';
import 'package:chat/src/services/encryption/encryption_service.dart';
import 'package:chat/src/services/message/message_service_contract.dart';
import 'package:chat/src/services/message/message_service_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'chat_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseFirestore>(),
  MockSpec<CollectionReference<Map<String, dynamic>>>(),
  MockSpec<DocumentReference<Map<String, dynamic>>>(),
  MockSpec<DocumentSnapshot<Map<String, dynamic>>>(),
  MockSpec<QuerySnapshot<Map<String, dynamic>>>(),
  MockSpec<Query<Map<String, dynamic>>>(),
  MockSpec<QueryDocumentSnapshot<Map<String, dynamic>>>(),
  MockSpec<DocumentChange<Map<String, dynamic>>>(),
])
void main() {
  late final MockFirebaseFirestore firebaseFirestore;
  late final MockCollectionReference collectionRef;
  late final MockDocumentReference docRef;
  late final MockQuerySnapshot querySnapshot;
  late final IEncryption encryption;
  late final IMessageService messageService;
  late final MockQuery query;
  late final MockDocumentChange documentChange;
  late final MockQueryDocumentSnapshot documentSnapshot;

  final Message message = Message(
    from: "2edwd",
    to: "dasdsd",
    contents: "Hey Baby!",
    time: DateTime.now(),
  );

  final Map<String, dynamic> messageMapFromServer = {
    "id": "dwdwdwd",
    "from": "2edwd",
    "to": "dasdsd",
    "contents": "Hey Baby!",
    "time": DateTime.now(),
  };

  final Map<String, dynamic> userMap = {
    "name": "Dabua",
    "id": "dasdsd",
    "username": "dasdsd",
    "email": "dwddw@gmkef.com",
    "photo_url":
        "https://images.unsplash.com/photo-1603320045158-61d0dc0fbb33?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    "last_seen": DateTime.now(),
    "active": false,
  };
  setUpAll(() {
    firebaseFirestore = MockFirebaseFirestore();
    collectionRef = MockCollectionReference();
    docRef = MockDocumentReference();
    querySnapshot = MockQuerySnapshot();
    documentChange = MockDocumentChange();
    query = MockQuery();
    final encrypter = Encrypter(AES(Key.fromLength(32)));
    encryption = EncryptionService(encrypter);
    documentSnapshot = MockQueryDocumentSnapshot();
    messageService = MessageService(firebaseFirestore, encryption: encryption);
    when(firebaseFirestore.collection("messages")).thenReturn(collectionRef);
    when(query.snapshots()).thenAnswer((realInvocation) {
      return Stream.value(querySnapshot);
    });
    when(collectionRef.doc(any)).thenReturn(docRef);
    when(
      collectionRef.where(any, isEqualTo: anyNamed("isEqualTo")),
    ).thenReturn(query);
  });

  group("Send and recieve messages", () {
    test("Should send message", () async {
      when(collectionRef.add(any)).thenAnswer((realInv) async => docRef);

      messageService.send(message);

      verify(collectionRef.add(message.toJSON())).called(1);
    });

    test("Should recieve messages", () async {
      when(
        querySnapshot.docChanges,
      ).thenAnswer((realInvocation) => [documentChange]);
      when(documentChange.type).thenReturn(DocumentChangeType.added);
      when(documentChange.doc).thenReturn(documentSnapshot);
      when(documentSnapshot.data()).thenReturn(messageMapFromServer);

      final messageStream = messageService.messages(
        activeUser: User.fromJSON(userMap),
      );
      final message = await messageStream.first;
      expect(message.id, messageMapFromServer["id"]);
    });
  });
}
