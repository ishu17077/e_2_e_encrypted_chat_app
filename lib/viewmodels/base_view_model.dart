import 'package:chat/chat.dart';
import 'package:e_2_e_encrypted_chat_app/data/datasources/datasource_contract.dart';
import 'package:e_2_e_encrypted_chat_app/models/chat.dart';
import 'package:e_2_e_encrypted_chat_app/models/local_message.dart';
import 'package:flutter/material.dart';

abstract class BaseViewModel {
  final IDataSource _dataSource;
  final IUserService _userService;
  const BaseViewModel(this._dataSource, this._userService);

  @protected
  Future<void> addMessage(LocalMessage message) async {
    if (!await _isExistingChat(message.chatId, message.message.from, null)) {
      final User? user = await _userService.fetch(message.message.from);
      if (user == null) {
        debugPrint("Cannot find user for id ${message.message.from}");
        return;
      }
      //TODO: Return chat id on successful chat creation in database
      await _createNewUser(user);
      await _createNewChat(message.message.from, user);
    }
  }

  Future<bool> _isExistingChat(
      //TODO: Future impl groups
      String? chatId,
      String? userId,
      String? groupId) async {
    assert(chatId != null || userId != null || groupId != null,
        "user_id and chat_id cannot be null");
    return await _dataSource.findChat(chatId: chatId, userId: userId) != null;
  }

  Future<void> _createNewChat(String userId, User from) async {
    Chat chat = Chat(userId);
    await _dataSource.addChat(chat);
  }

  Future<void> _createNewUser(User user) async {
    await _dataSource.addUser(user);
  }
}
