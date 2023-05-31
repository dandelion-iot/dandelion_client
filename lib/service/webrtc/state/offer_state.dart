import 'dart:convert';

import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/service/webrtc/abstract_state.dart';
import 'package:dandelion_client/service/websocket_service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class RTCOfferState implements RTCState {
  late final WebSocketService _ws = WebSocketService();

  @override
  Future handle(Map<String, dynamic> payload, RTCPeerConnection? pc) async {
    var description = RTCSessionDescription(payload['sdp'], payload['type']);
    await pc!.setRemoteDescription(description);
    await response(pc);
  }

  @override
  Future response(RTCPeerConnection? pc) async {
    print('send answer');
    var room = prefs.getString('room');
    var answer = await pc!.createAnswer();
    pc.setLocalDescription(answer);
    var payload = {'type': answer.type, 'room': room, 'sdp': answer.sdp};
    _ws.send(jsonEncode(payload));
  }
}
