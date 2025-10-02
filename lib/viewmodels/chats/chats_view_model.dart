import 'package:chat/chat.dart';
import 'package:secuchat/data/datasources/datasource_contract.dart';
import 'package:secuchat/models/chat.dart';
import 'package:secuchat/models/local_message.dart';
import 'package:secuchat/viewmodels/chats/base_view_model.dart';

class ChatsViewModel extends BaseViewModel {
  IDataSource _dataSource;
  IUserService userService;

  ChatsViewModel(this._dataSource, {required this.userService})
      : super(_dataSource, userService);
  Future<List<Chat>> getChats() async {
    final chats = await _dataSource.findAllChats();
    chats.forEach((Chat chat) {
      if (chat.from.id == null) {
        throw Exception("User id cannot be null in database");
      }
      userService.fetch(chat.from.id!).then((user) {
        if (user == null) {
          throw Exception(
              "User not found, the user might have deleted its account");
        }
        _dataSource.updateUser(user);
      });
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
