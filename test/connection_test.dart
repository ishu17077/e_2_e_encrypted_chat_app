// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
// import 'package:e_2_e_encrypted_chat_app/main.dart';

void main() async {
  //? Maybe this is not a bug, but a feature

  test('Checking for internet connection', () async {
    http.Response response = await http.get(
      Uri.parse('https://www.google.com'),
      headers: {"Accept": "application/json"},
    );
    print("\\\\x1B[32mInternet is phenomenal ;)");
    expectLater(response.statusCode, 200);
  });
}
