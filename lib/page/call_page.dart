import 'dart:convert';

import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/model/contact.dart';
import 'package:dandelion_client/service/webrtc/state/answer_state.dart';
import 'package:dandelion_client/service/webrtc/state/ice_state.dart';
import 'package:dandelion_client/service/webrtc/state/joined_state.dart';
import 'package:dandelion_client/service/webrtc/state/offer_state.dart';
import 'package:dandelion_client/service/webrtc/webrtc_context.dart';
import 'package:dandelion_client/service/websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CallPage extends StatefulWidget {
  final Contact? targetContact;
  final String? room;

  const CallPage({Key? key, required this.targetContact, this.room})
      : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late final WebSocketService _ws = WebSocketService();
  late final WebRTCContext _webRTCContext = WebRTCContext();

  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    await _webRTCContext.init(_localRenderer, _remoteRenderer);
    eventListener();

    if (widget.room != null) {
      print('Incoming call received');
      await prefs.setString("room", widget.room!);
      _webRTCContext.handleRequest(RTCJoinedState(), {});
    } else {
      _webRTCContext.requestRoom();
    }
  }

  Future eventListener() async {
    _ws.messageStream.listen((event) async {
      var payload = jsonDecode(event);
      var type = payload['type'];
      print('Receive type: $type');
      switch (type) {
        case 'room':
          await prefs.setString('room', payload['room']);
          _webRTCContext.joinRoom(widget.targetContact);
        case 'joined':
          _webRTCContext.handleRequest(RTCJoinedState(), payload);
          break;
        case 'offer':
          _webRTCContext.handleRequest(RTCOfferState(), payload);
          break;
        case 'answer':
          _webRTCContext.handleRequest(RTCAnswerState(), payload);
          break;
        case 'ice':
          _webRTCContext.handleRequest(RTCIceState(), payload);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.blue,
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              RTCVideoView(_localRenderer),
              Positioned(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 150,
                        height: 200,
                        child: RTCVideoView(_remoteRenderer),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void disconnect() {
    _webRTCContext.dispose();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
    _ws.dispose();
  }
}
