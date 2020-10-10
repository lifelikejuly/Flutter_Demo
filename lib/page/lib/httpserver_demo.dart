import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HttpServerDemo extends StatefulWidget {
  @override
  _HttpServerDemoState createState() => _HttpServerDemoState();
}

class _HttpServerDemoState extends State<HttpServerDemo> {
  WebSocketChannel channel;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('ws://echo.websocket.org');
  }

  _sendMessage() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Form(
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message'),
            ),
          ),
          StreamBuilder(
            stream: channel.stream,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),
    );
  }
}
