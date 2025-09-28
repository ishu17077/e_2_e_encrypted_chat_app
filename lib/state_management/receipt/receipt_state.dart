part of 'receipt_bloc.dart';

sealed class ReceiptState extends Equatable {
  const ReceiptState();
  factory ReceiptState.initial() => ReceiptInitial();
  factory ReceiptState.sent(Receipt receipt) => ReceiptSentSucess(receipt);
  factory ReceiptState.received(Receipt receipt) =>
      ReceiptRecievedSuccess(receipt);

  @override
  List<Object?> get props => [];
}

class ReceiptInitial extends ReceiptState {}

class ReceiptSentSucess extends ReceiptState {
  final Receipt receipt;
  const ReceiptSentSucess(this.receipt);

  @override
  List<Object?> get props => [receipt];
}

class ReceiptRecievedSuccess extends ReceiptState {
  final Receipt receipt;
  const ReceiptRecievedSuccess(this.receipt);

  @override
  List<Object?> get props => [receipt];
}
