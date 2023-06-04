import 'dart:async';
import 'dart:convert';

import 'package:dandelion_client/constant.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  static final WebSocketService _singleton = WebSocketService._internal();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  factory WebSocketService() => _singleton;

  WebSocketService._internal();

  late final Uri uri;
  late final WebSocketChannel ws;
  late final StreamController<String> _messageController = StreamController<String>.broadcast();
  late final Stream<String> _messageStream;

  Stream<String> get messageStream => _messageController.stream;

  Future init(String channel) async {
    String wsUrl = 'ws://$serverBaseUrl/webrtc/signal/$channel';
    print('Connect to $wsUrl');
    uri = Uri.parse(wsUrl);
    ws = WebSocketChannel.connect(uri);
    _messageStream = ws.stream.cast<String>();
    _messageStream.listen((event) {
      _messageController.add(event);
      _handleMessage(event);
    });
  }

  Future _handleMessage(String message) async {
    var payload = jsonDecode(message);
    var type = payload['type'];
    if (type == 'join') {
      var room = payload['room'];
      await prefs.setString('room', room);
      print('WEBSOCKET -> Receive joined message');
      navigatorKey.currentState?.pushNamed('/call');
    } else if (type == 'hangup') {
      print('WEBSOCKET -> Remote peer hangup');
      navigatorKey.currentState?.pushReplacementNamed('/contacts');
    }
  }

  bool isConnected() {
    return ws.closeCode == null && ws.closeReason == null;
  }

  void send(String msg) {
    ws.sink.add(msg);
  }

  void dispose() {
    ws.sink.close();
    _messageController.close();
  }
}
