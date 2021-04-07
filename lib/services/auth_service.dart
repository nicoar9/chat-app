import 'dart:convert';

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  Usuario usuario;

  Future login(String email, String password) async {
    final data = {'email': email, 'password': password};
    final url = Uri.parse('${Environment.socketUrl}/api/login');
    final resp = await http.post(
      url,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    print(resp.body);
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
    }
  }
}
