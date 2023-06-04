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
  late RTCVideoRenderer _localRenderer;
  late RTCVideoRenderer _remoteRenderer;

  bool _isLocalRendererInitialized = false;
  bool _isRemoteRendererInitialized = false;

  Future initializeLocalRenderer(RTCVideoRenderer localRenderer, MediaStream? localStream) async {
    pc = await createPeerConnection(stunServers, sdpConstraints);
    _localStream = localStream;

    _localStream!.getTracks().forEach((track) {
      pc!.addTrack(track, _localStream!);
    });

    localRenderer.srcObject = _localStream;

    pc!.onIceCandidate = (ice) {
      _sendIce(ice);
    };

    _localRenderer = localRenderer;
    _isLocalRendererInitialized = true;
  }

  Future initializeRemoteRenderer(RTCVideoRenderer remoteRenderer) async {
    pc!.onAddStream = (stream) {
      remoteRenderer.srcObject = stream;
      _remoteRenderer = remoteRenderer;
      _isRemoteRendererInitialized = true;
    };
  }

  bool isRemoteRendererInitialized() {
    return _isRemoteRendererInitialized;
  }

  bool isLocalRendererInitialized() {
    return _isLocalRendererInitialized;
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

  Future joinRoom(Contact? targetContact) async {
    var payload = {'type': 'join', 'target': targetContact!.cellPhoneNumber};
    _ws.send(jsonEncode(payload));
  }

  Future joined() async {
    var room = prefs.getString('room');
    var payload = {'type': 'joined', 'room': room};
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
    _localStream?.getTracks().forEach((track) => {
          track.stop(),
          _localStream?.removeTrack(track),
        });
    _localStream?.dispose();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    pc?.close();
  }
}
