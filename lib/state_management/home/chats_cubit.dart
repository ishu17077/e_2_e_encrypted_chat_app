import 'package:bloc/bloc.dart';
import 'package:e_2_e_encrypted_chat_app/models/chat.dart';
import 'package:e_2_e_encrypted_chat_app/viewmodels/chats_view_model.dart';

class ChatsCubit extends Cubit<List<Chat>> {
  final ChatsViewModel _chatViewModel;
  ChatsCubit(this._chatViewModel) : super([]);
  Future<void> chats() async {
    final chats = await _chatViewModel.getChats();
    emit(chats);
  }
}
