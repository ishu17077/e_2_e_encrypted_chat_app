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
      final User user = await _userService.fetch(message.message.from) ??
          User(
              name: 'Not Found!',
              email: "notfound@notfound.com",
              username: "notFound",
              photoUrl: null,
              lastSeen: DateTime.now());
      await _createNewChat(message.chatId, user);
    }
  }

  Future<bool> _isExistingChat(String chatId) async {
    return await _dataSource.findChat(chatId) != null;
  }

  Future<void> _createNewChat(String chatId, User from) async {
    Chat chat = Chat(chatId, from);
    await _dataSource.addChat(chat);
  }
}
