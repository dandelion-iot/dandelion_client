import 'dart:convert';

import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/service/webrtc/abstract_state.dart';
import 'package:dandelion_client/service/websocket_service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class RTCJoinedState implements RTCState {
  late final WebSocketService _ws = WebSocketService();

  @override
  Future handle(Map<String, dynamic> payload, RTCPeerConnection? pc) async {
    await response(pc);
  }

  @override
  Future response(RTCPeerConnection? pc) async {
    print('send offer');
    var room = prefs.getString('room');
    print('Room -> $room');
    var offer = await pc!.createOffer();
    pc.setLocalDescription(offer);
    var payload = {'type': offer.type,'room':room, 'sdp': offer.sdp};
    _ws.send(jsonEncode(payload));
  }
}
