import 'package:chat/chat.dart';
import 'package:e_2_e_encrypted_chat_app/data/datasources/datasource_contract.dart';
import 'package:e_2_e_encrypted_chat_app/models/local_message.dart';
import 'package:e_2_e_encrypted_chat_app/viewmodels/base_view_model.dart';

class ChatViewModel extends BaseViewModel {
  String get chatId => _chatId ?? '';
  String? _chatId;
  final IDataSource _dataSource;
  final IUserService _userService;
  int otherMessages = 0;

  ChatViewModel(this._dataSource, this._userService)
      : super(_dataSource, _userService);

  Future<List<LocalMessage>> getMessages(String chatId) async {
    final messages = await _dataSource.findMessages(chatId);
    if (messages.isNotEmpty) _chatId = chatId;
    return messages;
  }

  Future<void> sentMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.to, message, ReceiptStatus.sent);
    if (_chatId != null) return await _dataSource.addMessage(localMessage);
    //TODO: Transition from chat_id to user_id
    _chatId = localMessage.chatId;
    await addMessage(localMessage);
  }

  Future<void> recieveMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.from, message, ReceiptStatus.delivered);

    _chatId ??= localMessage.chatId;
    if (localMessage.chatId != chatId) {
      otherMessages++;
    }
    await addMessage(localMessage);
  }

  Future<void> updateMessageReceipt(Receipt receipt) async {
    await _dataSource.updateMessageReceipt(receipt.messageId, receipt.status);
  }
}
