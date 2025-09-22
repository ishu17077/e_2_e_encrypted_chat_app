import 'package:chat/chat.dart';
import 'package:chat/src/services/receipt/receipt_service_contract.dart';
import 'package:chat/src/services/receipt/receipt_service_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'firebase_test.mocks.dart';
import 'helpers.dart';

void main() {
  late final MockFirebaseFirestore firebaseFirestore;
  late final MockCollectionReference collectionRef;
  late final MockDocumentReference docRef;
  late final MockQuerySnapshot querySnapshot;
  late final IReceiptService sut;
  late final MockQuery query;
  late final MockDocumentChange documentChange;
  late final MockQueryDocumentSnapshot documentSnapshot;

  setUpAll(() {
    firebaseFirestore = MockFirebaseFirestore();
    collectionRef = MockCollectionReference();
    documentSnapshot = MockQueryDocumentSnapshot();
    documentChange = MockDocumentChange();
    query = MockQuery();
    querySnapshot = MockQuerySnapshot();
    docRef = MockDocumentReference();
    sut = ReceiptService(firebaseFirestore);

    when(firebaseFirestore.collection("receipts")).thenReturn(collectionRef);
    when(collectionRef.add(any)).thenAnswer((realInvocation) async => docRef);
    when(collectionRef.doc(any)).thenReturn(docRef);
    when(
      collectionRef.where(any, isEqualTo: anyNamed("isEqualTo")),
    ).thenReturn(query);
    when(docRef.id).thenReturn(receiptMap["id"]);
  });

  group("Should send and recieve receipts", () {
    test("Should send receipt", () async {
      final Receipt receipt = await sut.send(Receipt.fromJSON(receiptMap));
      
      verify(
        collectionRef.add(Receipt.fromJSON(receiptMap).toJSON()),
      ).called(1);
    });

    test("Should recieve receipts from user", () async {
      when(
        query.snapshots(),
      ).thenAnswer((realInvocation) => Stream.value(querySnapshot));
      when(querySnapshot.docChanges).thenReturn([documentChange]);
      when(documentChange.type).thenReturn(DocumentChangeType.added);
      when(documentChange.doc).thenReturn(documentSnapshot);
      when(documentSnapshot.data()).thenReturn(receiptMap);
      when(documentSnapshot.id).thenReturn(receiptMap["id"]);

      final receipt = await (sut.receipts(user: User.fromJSON(userMap))).first;
      expect(receipt.id, receiptMap["id"]);
    });
  });
}
