import 'dart:convert';

import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/model/contact.dart';
import 'package:dandelion_client/service/websocket_service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCContext {
  late final WebSocketService _ws = WebSocketService();

  late RTCPeerConnection _peerConnection;

  Future createConnection(RTCVideoRenderer localRenderer, RTCVideoRenderer remoteRenderer, MediaStream mediaStream) async {
    _peerConnection = await createPeerConnection(stunServers, sdpConstraints);

    mediaStream.getTracks().forEach((track) {
      _peerConnection.addTrack(track, mediaStream);
    });

    _peerConnection.onIceCandidate = (ice) {
      if (ice.candidate != null && _peerConnection.signalingState != RTCSignalingState.RTCSignalingStateClosed) {
        try {
          print(ice);
          sendIce(ice);
        } catch (e) {
          print('onIceCandidate error $e');
        }
      }
    };

    _peerConnection.onAddStream = (stream) {
      remoteRenderer.srcObject = stream;
    };
  }

  Future setCandidate(Map<String, dynamic> payload) async {
    var candidate = RTCIceCandidate(payload['candidate'], payload['sdpMid'], payload['sdpMLineIndex']);
    await _peerConnection.addCandidate(candidate);
  }

  Future setRemoteDescription(Map<String, dynamic> payload) async {
    var description = RTCSessionDescription(payload['sdp'], payload['type']);
    await _peerConnection.setRemoteDescription(description);
  }

  Future sendOffer() async {
    var room = prefs.getString('room');
    var offer = await _peerConnection.createOffer();
    _peerConnection.setLocalDescription(offer);
    var payload = {'type': offer.type, 'room': room, 'sdp': offer.sdp};
    await _peerConnection.setLocalDescription(offer);
    _ws.send(jsonEncode(payload));
  }

  Future sendAnswer() async {
    var room = prefs.getString('room');
    var answer = await _peerConnection.createAnswer();
    await _peerConnection.setLocalDescription(answer);
    var payload = {'type': answer.type, 'room': room, 'sdp': answer.sdp};
    _ws.send(jsonEncode(payload));
  }

  Future sendIce(RTCIceCandidate ice) async {
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

  Future createRoom(Contact targetContact) async {
    var payload = {'type': 'join', 'target': targetContact.cellPhoneNumber};
    _ws.send(jsonEncode(payload));
  }

  Future sendJoined() async {
    var room = prefs.getString('room');
    var payload = {'type': 'joined', 'room': room};
    _ws.send(jsonEncode(payload));
  }

  void dispose() {
    print('WebRTC service dispose executed');
    _peerConnection.dispose();
    _peerConnection.close();
  }
}
