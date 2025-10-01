import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ILocalCache {
  Future<void> save(String key, {required Map<String, dynamic> data});
  Map<String, dynamic> fetch(String key);
  Future<void> clear(String key);
}

class LocalCache implements ILocalCache {
  final SharedPreferences _sharedPreferences;

  const LocalCache(this._sharedPreferences);

  @override
  Map<String, dynamic> fetch(String key) {
    final json = _sharedPreferences.getString(key);
    final user = jsonDecode(json ?? "{}");
    if (user["last_seen"] != null) {
      user["last_seen"] = Timestamp.fromDate(DateTime.parse(user["last_seen"]));
    }
    return user;
  }

  @override
  Future<void> save(String key, {required Map<String, dynamic> data}) async {
    data["last_seen"] = (data["last_seen"] as DateTime).toIso8601String();
    final encodeData = jsonEncode(data);
    final result = await _sharedPreferences.setString(key, encodeData);
    debugPrint('Save result for $key: $result');
  }

  @override
  Future<void> clear(String key) async {
    await _sharedPreferences.remove(key);
  }
}
