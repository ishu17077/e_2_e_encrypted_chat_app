import 'dart:convert';

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
    return jsonDecode(_sharedPreferences.getString(key) ?? "{}");
  }

  @override
  Future<void> save(String key, {required Map<String, dynamic> data}) async {
    await _sharedPreferences.setString(key, jsonEncode(data));
  }

  Future<void> clear(String key) async {
    await _sharedPreferences.remove(key);
  }
}
