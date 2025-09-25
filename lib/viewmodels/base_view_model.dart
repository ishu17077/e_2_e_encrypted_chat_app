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
    if (!await _isExistingChat(message.chatId)) {
      final User? user = await _userService.fetch(message.message.from);
      if (user == null) {
        debugPrint("Cannot find user for id ${message.message.from}");
        return;
      }
      await _createNewUser(user);
      await _createNewChat(message.chatId, user);
    }
  }

  Future<bool> _isExistingChat(String chatId) async {
    return await _dataSource.findChat(chatId) != null;
  }

  Future<void> _createNewChat(String userId, User from) async {
    Chat chat = Chat(userId);
    await _dataSource.addChat(chat);
  }

  Future<void> _createNewUser(User user) async {
    await _dataSource.addUser(user);
  }
}
