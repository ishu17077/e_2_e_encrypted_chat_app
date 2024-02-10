import 'package:cloud_firestore/cloud_firestore.dart';

enum ReceiptStatus { sent, delievered, read, undecryptable }

extension EnumParsing on ReceiptStatus {
  String value() {
    return this.toString().split('.').last;
  }

  static ReceiptStatus fromString(String status) {
    return ReceiptStatus.values
        .firstWhere((element) => element.value() == status);
  }
}

class Receipt {
  final String recipient;
  final String messageFirestoreId;
  final ReceiptStatus status;
  final DateTime dateTime;
  String? _id;
  String? get id => _id;
  Receipt(
      {required this.recipient,
      required this.messageFirestoreId,
      required this.status,
      required this.dateTime});

  Map<String, dynamic> toJson() => {
        'receipient': recipient,
        'messageFirestoreId': messageFirestoreId,
        'status': status.value(),
        'timestamp': Timestamp.fromDate(dateTime),
      };

  factory Receipt.fromJson(Map<String, dynamic> mapReceipt) {
    Receipt receipt = Receipt(
      recipient: mapReceipt['receipt'],
      messageFirestoreId: mapReceipt['messageFirestoreId'],
      status: mapReceipt['status'],
      dateTime:
          ((mapReceipt['timestamp'] ?? Timestamp.now()) as Timestamp).toDate(),
    );
    return receipt;
  }
}
