import 'package:chat_app/global/environment.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  IO.Socket get socket => this._socket;
  ServerStatus get serverStatus => this._serverStatus;

  void connect() async {
    // Dart client
    this._socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true
    });
    this._socket.connect();

    this._socket.onConnect((_) {
      print('hola mundo');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // socket.on('event', (data) => print('hhoasdohad'));
  }

  void disconnect() {
    this._socket.disconnect();
  }
}
