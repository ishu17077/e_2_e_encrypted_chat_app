import 'package:chat/chat.dart';
import 'package:e_2_e_encrypted_chat_app/data/datasources/datasource_contract.dart';
import 'package:e_2_e_encrypted_chat_app/models/chat.dart';
import 'package:e_2_e_encrypted_chat_app/models/local_message.dart';
import 'package:e_2_e_encrypted_chat_app/viewmodels/base_view_model.dart';

class ChatsViewModel extends BaseViewModel {
  IDataSource _dataSource;
  IUserService userService;

  ChatsViewModel(this._dataSource, {required this.userService})
      : super(_dataSource, userService);
  Future<List<Chat>> getChats() async {
    final chats = await _dataSource.findAllChats();
    await Future.forEach(chats, (Chat chat) async {
      final user = await userService.fetch(chat.userId);
      if (user != null) {
        chat.from = user;
      }
    });
    return chats;
  }

  Future<void> receivedMessage(String userId, Message message) async {
    LocalMessage localMessage = LocalMessage(
        message,
        Receipt(
            messageId: '',
            recipientId: '',
            status: ReceiptStatus.delivered,
            time: DateTime.now()),
        userId: userId);
    await addMessage(localMessage);
  }
}
