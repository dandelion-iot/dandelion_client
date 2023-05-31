import 'dart:convert';

import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/model/contact.dart';
import 'package:dandelion_client/service/webrtc/abstract_state.dart';
import 'package:dandelion_client/service/webrtc/state/answer_state.dart';
import 'package:dandelion_client/service/webrtc/state/ice_state.dart';
import 'package:dandelion_client/service/webrtc/state/joined_state.dart';
import 'package:dandelion_client/service/webrtc/state/offer_state.dart';
import 'package:dandelion_client/service/websocket_service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCContext {
  static final WebRTCContext _singleton = WebRTCContext._internal();

  WebRTCContext._internal();

  factory WebRTCContext() => _singleton;

  late final WebSocketService _ws = WebSocketService();

  MediaStream? _localStream;
  RTCPeerConnection? pc;

  Future init(RTCVideoRenderer localRenderer, RTCVideoRenderer remoteRenderer) async {
    pc = await createPeerConnection(stunServers, sdpConstraints);

    final mediaConstraints = {
      'audio': true,
      'video': {'facingMode': 'user'}
    };

    _localStream = await Helper.openCamera(mediaConstraints);

    _localStream!.getTracks().forEach((track) {
      pc!.addTrack(track, _localStream!);
    });

    localRenderer.srcObject = _localStream;

    pc!.onIceCandidate = (ice) {
      _sendIce(ice);
    };

    pc!.onAddStream = (stream) {
      remoteRenderer.srcObject = stream;
    };

    if (_localStream != null) {
      localRenderer.srcObject = _localStream;
    }
  }

  Future _sendIce(RTCIceCandidate ice) async {
    var room = prefs.getString('room');
    var payload = {
      'type': 'ice',
      'room': room,
      'candidate': ice.candidate,
      'sdpMid': ice.sdpMid,
      'sdpMLineIndex': ice.sdpMLineIndex,
    };
    _ws.send(jsonEncode(payload));
  }

  Future requestRoom() async {
    var payload = {'type': 'room'};
    _ws.send(jsonEncode(payload));
  }

  Future joinRoom(Contact? targetContact) async {
    var room = prefs.getString('room');
    var payload = {
      'type': 'join',
      'room': room,
      'target': targetContact!.cellPhoneNumber
    };
    _ws.send(jsonEncode(payload));
  }

  Future handleRequest(RTCState state, Map<String, dynamic> payload) async {
    switch (state.runtimeType) {
      case RTCOfferState:
        var offerState = state as RTCOfferState;
        offerState.handle(payload, pc);
        break;
      case RTCJoinedState:
        var joinedState = state as RTCJoinedState;
        joinedState.handle(payload, pc);
        break;
      case RTCIceState:
        var iceState = state as RTCIceState;
        iceState.handle(payload, pc);
        break;
      case RTCAnswerState:
        var answerState = state as RTCAnswerState;
        answerState.handle(payload, pc);
        break;
    }
  }

  void dispose() {
    _localStream?.getTracks().forEach((track) => track.stop());
    pc?.close();
  }
}
