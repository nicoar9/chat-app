import 'dart:convert';

import 'package:chat_app/global/environment.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  Future login(String email, String password) async {
    final data = {'email': email, 'password': password};
    final url = Uri.parse('${Environment.socketUrl}/api/login');
    final resp = await http.post(
      url,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    print(resp.body);
  }
}
