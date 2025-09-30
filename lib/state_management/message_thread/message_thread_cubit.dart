import 'package:bloc/bloc.dart';
import 'package:secuchat/models/chat.dart';
import 'package:secuchat/models/local_message.dart';
import 'package:secuchat/viewmodels/chats/chat_view_model.dart';

class MessageThreadCubit extends Cubit<List<LocalMessage>> {
  final ChatViewModel _chatViewModel;
  MessageThreadCubit(this._chatViewModel) : super([]);

  Future<void> messages(String chatId) async {
    final messages = await _chatViewModel.getMessages(chatId);
    emit(messages);
  }
}
