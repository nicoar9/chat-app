import 'dart:io';

import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  List<ChatMessage> _messages = [];

  bool _isTexting = false;

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('mensaje-personal', _listenMessage);

    _loadHistory(this.chatService.userFor.uid);
  }

  void _loadHistory(String userID) async {
    List<Mensaje> chat = await this.chatService.getChat(userID);
    final history = chat.map(
      (m) => new ChatMessage(
        text: m.mensaje,
        uid: m.de,
        animationController: new AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 0),
        )..forward(),
      ),
    );
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenMessage(dynamic data) {
    ChatMessage message = ChatMessage(
      text: data["mensaje"],
      uid: data["de"],
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final userFor = chatService.userFor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: Text(
                userFor.nombre.substring(0, 2),
                style: TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              userFor.nombre,
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) =>
                    _messages[index],
                reverse: true,
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              height: 50,
              child: _inputChat(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String text) {
                  setState(() {
                    if (text.trim().length > 0) {
                      _isTexting = true;
                    } else {
                      _isTexting = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Send message',
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Send'),
                      onPressed: _isTexting
                          ? () => _handleSubmit(_textController.text.trim())
                          : null)
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: Icon(
                              Icons.send,
                            ),
                            onPressed: _isTexting
                                ? () =>
                                    _handleSubmit(_textController.text.trim())
                                : null),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    if (text.length == 0) return;
    final _newMessage = ChatMessage(
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
      ),
      uid: authService.usuario.uid,
      text: text,
    );
    _messages.insert(0, _newMessage);
    _newMessage.animationController.forward();
    setState(() {
      _isTexting = false;
    });
    this.socketService.socket.emit('mensaje-personal', {
      'de': authService.usuario.uid,
      'para': this.chatService.userFor.uid,
      'mensaje': text,
    });
    _textController.clear();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _messages.forEach((message) => message.animationController.dispose());

    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
