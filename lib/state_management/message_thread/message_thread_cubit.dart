import 'package:bloc/bloc.dart';
import 'package:e_2_e_encrypted_chat_app/models/chat.dart';
import 'package:e_2_e_encrypted_chat_app/models/local_message.dart';
import 'package:e_2_e_encrypted_chat_app/viewmodels/chat_view_model.dart';

class MessageThreadCubit extends Cubit<List<LocalMessage>> {
  final ChatViewModel _chatViewModel;
  MessageThreadCubit(this._chatViewModel) : super([]);

  Future<void> messages(String chatId) async {
    final messages = await _chatViewModel.getMessages(chatId);

    emit(messages);
  }
}
