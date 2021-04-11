import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';

class ChatService with ChangeNotifier {
  Usuario userFor;

  Future<List<Mensaje>> getChat(String userID) async {
    final url = Uri.parse(
      '${Environment.socketUrl}/api/mensajes/$userID',
    );

    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken()
    });

    final mensajesResp = mensajesResponseFromJson(resp.body);

    return mensajesResp.mensajes;
  }
}
